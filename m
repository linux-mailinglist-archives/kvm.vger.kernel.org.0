Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BB53DBAAF
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 16:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239184AbhG3Ofw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 10:35:52 -0400
Received: from smtp-fw-80007.amazon.com ([99.78.197.218]:4849 "EHLO
        smtp-fw-80007.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbhG3Ofv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 10:35:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627655747; x=1659191747;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=0FsLXimCNBTR48j3aYbh34ic1ti4XjTilcok0yp9pGE=;
  b=qIQ/aVNrpLMvOA2Gtj4/wIPiV/8eYYFdbHboMSGE8i9xct5UHQDZSfbj
   On9mohGq+58n9BUySSOyAYcccM+pgFBjWiEJSvJuWp/6TXjIMBFWOwtqe
   WfIaEJtyfKo2i+QpbHaJ/pOBK8CntDNT+LJTc3rBXqSrPbEFHQfX4L+lX
   I=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="15987416"
Subject: Re: [PATCH 4/4] KVM: selftests: Test access to XMM fast hypercalls
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-2b-baacba05.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 30 Jul 2021 14:35:40 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-baacba05.us-west-2.amazon.com (Postfix) with ESMTPS id 7B42AA1778;
        Fri, 30 Jul 2021 14:35:39 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.160.66) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 14:35:35 +0000
Date:   Fri, 30 Jul 2021 16:35:31 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210730143530.GD20232@u366d62d47e3651.ant.amazon.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-5-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210730122625.112848-5-vkuznets@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D36UWB004.ant.amazon.com (10.43.161.49) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 02:26:25PM +0200, Vitaly Kuznetsov wrote:
> HYPERV_CPUID_FEATURES.EDX and an 'XMM fast' hypercall is issued.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/hyperv.h     |  5 ++-
>  .../selftests/kvm/x86_64/hyperv_features.c    | 41 +++++++++++++++++--
>  2 files changed, 42 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> index 412eaee7884a..b66910702c0a 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> @@ -117,7 +117,7 @@
>  #define HV_X64_GUEST_DEBUGGING_AVAILABLE               BIT(1)
>  #define HV_X64_PERF_MONITOR_AVAILABLE                  BIT(2)
>  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE      BIT(3)
> -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE          BIT(4)
> +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE           BIT(4)
>  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE              BIT(5)
>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE            BIT(8)
>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE           BIT(10)
> @@ -182,4 +182,7 @@
>  #define HV_STATUS_INVALID_CONNECTION_ID                18
>  #define HV_STATUS_INSUFFICIENT_BUFFERS         19
> 
> +/* hypercall options */
> +#define HV_HYPERCALL_FAST_BIT          BIT(16)
> +
>  #endif /* !SELFTEST_KVM_HYPERV_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> index af27c7e829c1..91d88aaa9899 100644
> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> @@ -47,6 +47,7 @@ static void do_wrmsr(u32 idx, u64 val)
>  }
> 
>  static int nr_gp;
> +static int nr_ud;
> 
>  static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
>                             vm_vaddr_t output_address)
> @@ -80,6 +81,12 @@ static void guest_gp_handler(struct ex_regs *regs)
>                 regs->rip = (uint64_t)&wrmsr_end;
>  }
> 
> +static void guest_ud_handler(struct ex_regs *regs)
> +{
> +       nr_ud++;
> +       regs->rip += 3;
> +}
> +
>  struct msr_data {
>         uint32_t idx;
>         bool available;
> @@ -90,6 +97,7 @@ struct msr_data {
>  struct hcall_data {
>         uint64_t control;
>         uint64_t expect;
> +       bool ud_expected;
>  };
> 
>  static void guest_msr(struct msr_data *msr)
> @@ -117,13 +125,26 @@ static void guest_msr(struct msr_data *msr)
>  static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
>  {
>         int i = 0;
> +       u64 res, input, output;
> 
>         wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
>         wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> 
>         while (hcall->control) {
> -               GUEST_ASSERT(hypercall(hcall->control, pgs_gpa,
> -                                      pgs_gpa + 4096) == hcall->expect);
> +               nr_ud = 0;
> +               if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> +                       input = pgs_gpa;
> +                       output = pgs_gpa + 4096;
> +               } else {
> +                       input = output = 0;
> +               }
> +
> +               res = hypercall(hcall->control, input, output);
> +               if (hcall->ud_expected)
> +                       GUEST_ASSERT(nr_ud == 1);

Should we also do WRITE_ONCE(nr_ur, 0) here? or perhaps pass the the
expected value of nr_ud + 1 in hcall->ud_expected from caller and do,

    if (hcall->ud_expected)
        GUEST_ASSERT(nr_ud == hcall->ud_expected);

This way there can be other test that can also expect a UD.

> +               else
> +                       GUEST_ASSERT(res == hcall->expect);
> +
>                 GUEST_SYNC(i++);
>         }
> 
> @@ -552,8 +573,18 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
>                         recomm.ebx = 0xfff;
>                         hcall->expect = HV_STATUS_SUCCESS;
>                         break;
> -
>                 case 17:
> +                       /* XMM fast hypercall */
> +                       hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
> +                       hcall->ud_expected = true;
> +                       break;
> +               case 18:
> +                       feat.edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> +                       hcall->ud_expected = false;
> +                       hcall->expect = HV_STATUS_SUCCESS;
> +                       break;
> +
> +               case 19:
>                         /* END */
>                         hcall->control = 0;
>                         break;
> @@ -625,6 +656,10 @@ int main(void)
>         /* Test hypercalls */
>         vm = vm_create_default(VCPU_ID, 0, guest_hcall);
> 
> +       vm_init_descriptor_tables(vm);
> +       vcpu_init_descriptor_tables(vm, VCPU_ID);
> +       vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
> +
>         /* Hypercall input/output */
>         hcall_page = vm_vaddr_alloc_pages(vm, 2);
>         memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> --
> 2.31.1
> 



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



