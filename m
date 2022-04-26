Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D4650FFE7
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 16:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351373AbiDZODv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 10:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351375AbiDZODs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 10:03:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBC41A82C;
        Tue, 26 Apr 2022 07:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650981634; x=1682517634;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cAoqrdeOsrq5KtUjQou6zsgNtf+NljDbb1uC4qNAX4I=;
  b=EKRG4Rs6rByl/BCPkLHuPQ3gwMyImthUV5swwUBzOyghtaZ7KJ2RjULR
   Y/00oTXml/7KcWCSAnahE4r7lVEdS00h8xwDKTBRtoi/ampnTrSNLdUxG
   0fpcaQ21MDgm7eMY2+biuDzna/nRcobegXGdJfQ3dPG4KMhuLkA8R1nmv
   Ls3Y9LoCeRXUnJKUSx1lFho0HhTNOOS4hYj1gX/3f5e2WQs7/OYXNgTUC
   815Y/gzZmrm6JujvrI+KycyL041Hrw8yFIs+7bTRc847urLz4AAFgdjXM
   0o3UiV2P6nvquwskOe2K8JMGux/GN/RttIap+S+haBnRfLYz9+e/8d7qc
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="265390910"
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="265390910"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 07:00:29 -0700
X-IronPort-AV: E=Sophos;i="5.90,291,1643702400"; 
   d="scan'208";a="558322013"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 07:00:23 -0700
Date:   Tue, 26 Apr 2022 22:00:18 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>
Subject: Re: [PATCH v8 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220426140013.GA11796@gao-cwp>
References: <20220411090447.5928-1-guang.zeng@intel.com>
 <20220411090447.5928-7-guang.zeng@intel.com>
 <YlmDtC73u/AouMsu@google.com>
 <080d6ced254e56dbad2910447f81c5ea976fc419.camel@redhat.com>
 <6475522c58aec5db3ee0a5ccd3230c63a2f013a9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6475522c58aec5db3ee0a5ccd3230c63a2f013a9.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>Palo, Sean, Any update?
>
>After thinking more about this, I actualy think I will do something
>different, something that actually was proposed here, and I was against it:
>
>
>1. I will add new inhibit APICV_INHIBIT_REASON_RO_SETTINGS, which will be set
>first time any vCPU touches apic id and/or apic base because why not...
>
>That will take care of non nested case cleanly, and will take care of IPIv
>for now (as long as it does't support nesting).

Yes. This works well with intel IPIv.

>
>2. For my nested AVIC, I will do 2 things:
>
>   a. My code never reads L1 apic ids, and always uses vcpu_id, thus
>      in theory, if I just ignore the problem, and the guest changes apic ids,
>      the nested AVIC will just keep on using initial apic ids, thus there is  no danger
>      of CVE like issue if the guest tries to change theses ids in the 'right' time.
>
>   b. on each nested vm entry I'll just check that apic id is not changed from the default,
>      if AVIC is enabled for the nested guest.
>
>      if so the nested entry will fail (best with kvm_vm_bugged) to get attention of
>      the user, but I can just fail it with standard vm exit reason of 0xFFFFFFFF.

For sake of simplicity, I prefer to make APIC ID read-only for VMs that
supports (nested) AVIC or IPIv (KVM can check guest CPUID/MSR to know
this). When guest attempts to change read-only APIC ID, KVM can raise an
internal error, saying KVM cannot emulate this action. To get rid of such
an error, users should launch the VM with nested AVIC/IPIv disabled or
upgrade VM kernel to not change APIC ID.
