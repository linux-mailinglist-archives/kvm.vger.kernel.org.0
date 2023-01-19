Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D629673E0F
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 16:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbjASP6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 10:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjASP6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 10:58:13 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2D68386F;
        Thu, 19 Jan 2023 07:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674143885; x=1705679885;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J9mrTz3Ueu2u+3Yj0odHKZAg2uOr91Z2TdZhouXetTY=;
  b=T/FO1KFoI1tWceJL/3Wsik3mFOMKhr64Vy+VNCKidxBpM70eHvwtKpfP
   YpxAhyeLoTAsFxP+YxptnEKpkD+/04SHyhLrgqFA4On6cOlRTXtwRTtb4
   MSGTiI7VH3Uu45YTA590jMdfy05clETChENJ/Afzwhc8tlgh4t9ONURhF
   8qCbVFQwtpKu/e8S38MMzy+xGqD+i1DNKTgkIZ4WBCGe7ggAx8GIe26Fz
   OIdrLjj9QCHhRnz2/1Zpc26cX41IFWYD/v2dn6wJTRrTwOYeNmSV18hcc
   9nO+vXsMf2iJE5Pb/5zFRXoSBkYSe2nIYoFlaoU1fmvR43QTtoFOelHOQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="304998780"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="304998780"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:58:05 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="905564952"
X-IronPort-AV: E=Sophos;i="5.97,229,1669104000"; 
   d="scan'208";a="905564952"
Received: from yihuaxu1-mobl1.ccr.corp.intel.com (HELO localhost) ([10.249.171.116])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 07:58:03 -0800
Date:   Thu, 19 Jan 2023 23:58:00 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        seanjc@google.com, Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH] KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET
Message-ID: <20230119155800.fiypvvzoalnfavse@linux.intel.com>
References: <20221228110410.1682852-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228110410.1682852-1-pbonzini@redhat.com>
User-Agent: NeoMutt/20171215
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

> diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> index 721f6a693799..dae510c263b4 100644
> --- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
> @@ -962,6 +962,12 @@ int main(int argc, char *argv[])
>  	}
>  
>   done:
> +	struct kvm_xen_hvm_attr evt_reset = {
> +		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
> +		.u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
> +	};
> +	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);
> +
>  	alarm(0);
>  	clock_gettime(CLOCK_REALTIME, &max_ts);
>  

This change generates a build failure with error message: 
"error: a label can only be part of a statement and a declaration is not a statement".

Moving the definition of evt_reset to the beginning of main() can fix it:

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index dae510c263b4..d71f1508bb21 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -623,6 +623,10 @@ int main(int argc, char *argv[])
        rs->state = 0x5a;

        bool evtchn_irq_expected = false;
+       struct kvm_xen_hvm_attr evt_reset = {
+               .type = KVM_XEN_ATTR_TYPE_EVTCHN,
+               .u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
+       };

        for (;;) {
                volatile struct kvm_run *run = vcpu->run;
@@ -962,10 +966,6 @@ int main(int argc, char *argv[])
        }

  done:
-       struct kvm_xen_hvm_attr evt_reset = {
-               .type = KVM_XEN_ATTR_TYPE_EVTCHN,
-               .u.evtchn.flags = KVM_XEN_EVTCHN_RESET,
-       };
        vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &evt_reset);

        alarm(0);

B.R.
Yu
