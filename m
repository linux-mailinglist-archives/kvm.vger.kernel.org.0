Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB37917C2F2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 17:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgCFQ3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 11:29:15 -0500
Received: from mga17.intel.com ([192.55.52.151]:53413 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgCFQ3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 11:29:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Mar 2020 08:29:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,522,1574150400"; 
   d="gz'50?scan'50,208,50";a="441994679"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 06 Mar 2020 08:29:05 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jAFqS-000Alr-Ni; Sat, 07 Mar 2020 00:29:04 +0800
Date:   Sat, 7 Mar 2020 00:28:15 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Luwei Kang <luwei.kang@intel.com>
Cc:     kbuild-all@lists.01.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, mingo@redhat.com, acme@kernel.org,
        mark.rutland@arm.com, alexander.shishkin@linux.intel.com,
        jolsa@redhat.com, namhyung@kernel.org, tglx@linutronix.de,
        bp@alien8.de, hpa@zytor.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        pawan.kumar.gupta@linux.intel.com, ak@linux.intel.com,
        thomas.lendacky@amd.com, fenghua.yu@intel.com,
        kan.liang@linux.intel.com, like.xu@linux.intel.com
Subject: Re: [PATCH v1 05/11] KVM: x86/pmu: Add support to reprogram PEBS
 event for guest counters
Message-ID: <202003070038.amFy5Etu%lkp@intel.com>
References: <1583431025-19802-6-git-send-email-luwei.kang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1583431025-19802-6-git-send-email-luwei.kang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Luwei,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on kvm/linux-next]
[also build test ERROR on tip/perf/core tip/auto-latest v5.6-rc4 next-20200306]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Luwei-Kang/PEBS-virtualization-enabling-via-DS/20200306-013049
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git linux-next
config: x86_64-randconfig-h003-20200305 (attached as .config)
compiler: gcc-7 (Debian 7.5.0-5) 7.5.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   ld: arch/x86/kvm/pmu.o: in function `pmc_reprogram_counter':
>> arch/x86/kvm/pmu.c:199: undefined reference to `perf_x86_pmu_unset_auto_reload'

vim +199 arch/x86/kvm/pmu.c

   101	
   102	static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
   103					  unsigned config, bool exclude_user,
   104					  bool exclude_kernel, bool intr,
   105					  bool in_tx, bool in_tx_cp)
   106	{
   107		struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
   108		struct perf_event *event;
   109		struct perf_event_attr attr = {
   110			.type = type,
   111			.size = sizeof(attr),
   112			.pinned = true,
   113			.exclude_idle = true,
   114			.exclude_host = 1,
   115			.exclude_user = exclude_user,
   116			.exclude_kernel = exclude_kernel,
   117			.config = config,
   118			.disabled = 1,
   119		};
   120		bool pebs = test_bit(pmc->idx, (unsigned long *)&pmu->pebs_enable);
   121	
   122		attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
   123	
   124		if (in_tx)
   125			attr.config |= HSW_IN_TX;
   126		if (in_tx_cp) {
   127			/*
   128			 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
   129			 * period. Just clear the sample period so at least
   130			 * allocating the counter doesn't fail.
   131			 */
   132			attr.sample_period = 0;
   133			attr.config |= HSW_IN_TX_CHECKPOINTED;
   134		}
   135	
   136		if (pebs) {
   137			/*
   138			 * Host never knows the precision level set by guest.
   139			 * Force Host's PEBS event to precision level 1, which will
   140			 * not impact the accuracy of the results for guest PEBS events.
   141			 * Because,
   142			 * - For most cases, there is no difference among precision
   143			 *   level 1 to 3 for PEBS events.
   144			 * - The functions as below checks the precision level in host.
   145			 *   But the results from these functions in host are replaced
   146			 *   by guest when sampling the guest.
   147			 *   The accuracy for guest PEBS events will not be impacted.
   148			 *    -- event_constraints() impacts the index of counter.
   149			 *	The index for host event is exactly the same as guest.
   150			 *	It's decided by guest.
   151			 *    -- pebs_update_adaptive_cfg() impacts the value of
   152			 *	MSR_PEBS_DATA_CFG. When guest is switched in,
   153			 *	the MSR value will be replaced by the value from guest.
   154			 *    -- setup_sample () impacts the output of a PEBS record.
   155			 *	Guest handles the PEBS records.
   156			 */
   157			attr.precise_ip = 1;
   158			/*
   159			 * When the host's PMI handler completes, it's going to
   160			 * enter the guest and trigger the guest's PMI handler.
   161			 *
   162			 * At this moment, this function may be called by
   163			 * kvm_pmu_handle_event(). However the next sample_period
   164			 * hasn't been determined by guest yet and the left period,
   165			 * which probably be 0, is used for current sample_period.
   166			 *
   167			 * In this case, perf will mistakenly treat it as non
   168			 * sampling events. The PEBS event will error out.
   169			 *
   170			 * Fill it with maximum period to prevent the error out.
   171			 * The guest PMI handler will soon reprogram the counter.
   172			 */
   173			if (!attr.sample_period)
   174				attr.sample_period = (-1ULL) & pmc_bitmask(pmc);
   175		}
   176	
   177		event = perf_event_create_kernel_counter(&attr, -1, current,
   178							 (intr || pebs) ?
   179							 kvm_perf_overflow_intr :
   180							 kvm_perf_overflow, pmc);
   181		if (IS_ERR(event)) {
   182			pr_debug_ratelimited("kvm_pmu: event creation failed %ld for pmc->idx = %d\n",
   183				    PTR_ERR(event), pmc->idx);
   184			return;
   185		}
   186	
   187		if (pebs) {
   188			event->guest_dedicated_idx = pmc->idx;
   189			/*
   190			 * For guest PEBS events, guest takes the responsibility to
   191			 * drain PEBS buffers, and load proper values to reset counters.
   192			 *
   193			 * Host will unconditionally set auto-reload flag for PEBS
   194			 * events with fixed period which is not necessary. Host should
   195			 * do nothing in drain_pebs() but inject the PMI into the guest.
   196			 *
   197			 * Unset the auto-reload flag for guest PEBS events.
   198			 */
 > 199			perf_x86_pmu_unset_auto_reload(event);
   200		}
   201		pmc->perf_event = event;
   202		pmc_to_pmu(pmc)->event_count++;
   203		perf_event_enable(event);
   204		clear_bit(pmc->idx, pmc_to_pmu(pmc)->reprogram_pmi);
   205	}
   206	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--HcAYCG3uE/tztfnV
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--HcAYCG3uE/tztfnV--
