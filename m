Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B793DBB7F
	for <lists+kvm@lfdr.de>; Fri, 30 Jul 2021 17:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbhG3PBy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 11:01:54 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:52309 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239030AbhG3PBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 11:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1627657310; x=1659193310;
  h=date:from:to:cc:message-id:references:mime-version:
   in-reply-to:subject;
  bh=kmZvjwXOQUAejKr+gnf0Zxf4PHoVVd4Xm45+XI/Os8g=;
  b=ivuOCU/zqKiSYOpxPOmrf7rR2xTnHX1QGbMyEF7HiQpWx81U3XEv/9kJ
   8ggkjTfbv2X+pObBJfDk1zcLlHLd8yJLmwR+bPRZFC7QiT+3uui5odJJC
   j4OpDfF8C9DG7NGTAebk0sGU2uR9Odu9KA2dt+2Ur+kIR6f7bnvYw/grD
   8=;
X-IronPort-AV: E=Sophos;i="5.84,282,1620691200"; 
   d="scan'208";a="129091375"
Subject: Re: [PATCH 4/4] KVM: selftests: Test access to XMM fast hypercalls
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 30 Jul 2021 15:01:43 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 18728A1C90;
        Fri, 30 Jul 2021 15:01:39 +0000 (UTC)
Received: from u366d62d47e3651.ant.amazon.com (10.43.161.175) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Fri, 30 Jul 2021 15:01:36 +0000
Date:   Fri, 30 Jul 2021 17:01:32 +0200
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
CC:     <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        <linux-kernel@vger.kernel.org>
Message-ID: <20210730150131.GA31075@u366d62d47e3651.ant.amazon.com>
References: <20210730122625.112848-1-vkuznets@redhat.com>
 <20210730122625.112848-5-vkuznets@redhat.com>
 <20210730143530.GD20232@u366d62d47e3651.ant.amazon.com>
 <878s1namap.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <878s1namap.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [10.43.161.175]
X-ClientProxiedBy: EX13D45UWB003.ant.amazon.com (10.43.161.67) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 30, 2021 at 04:50:06PM +0200, Vitaly Kuznetsov wrote:
> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you can confirm the sender and know the content is safe.
> 
> 
> 
> Siddharth Chandrasekaran <sidcha@amazon.de> writes:
> 
> > On Fri, Jul 30, 2021 at 02:26:25PM +0200, Vitaly Kuznetsov wrote:
> >> HYPERV_CPUID_FEATURES.EDX and an 'XMM fast' hypercall is issued.
> >>
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  .../selftests/kvm/include/x86_64/hyperv.h     |  5 ++-
> >>  .../selftests/kvm/x86_64/hyperv_features.c    | 41 +++++++++++++++++--
> >>  2 files changed, 42 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> >> index 412eaee7884a..b66910702c0a 100644
> >> --- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> >> +++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
> >> @@ -117,7 +117,7 @@
> >>  #define HV_X64_GUEST_DEBUGGING_AVAILABLE               BIT(1)
> >>  #define HV_X64_PERF_MONITOR_AVAILABLE                  BIT(2)
> >>  #define HV_X64_CPU_DYNAMIC_PARTITIONING_AVAILABLE      BIT(3)
> >> -#define HV_X64_HYPERCALL_PARAMS_XMM_AVAILABLE          BIT(4)
> >> +#define HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE           BIT(4)
> >>  #define HV_X64_GUEST_IDLE_STATE_AVAILABLE              BIT(5)
> >>  #define HV_FEATURE_FREQUENCY_MSRS_AVAILABLE            BIT(8)
> >>  #define HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE           BIT(10)
> >> @@ -182,4 +182,7 @@
> >>  #define HV_STATUS_INVALID_CONNECTION_ID                18
> >>  #define HV_STATUS_INSUFFICIENT_BUFFERS         19
> >>
> >> +/* hypercall options */
> >> +#define HV_HYPERCALL_FAST_BIT          BIT(16)
> >> +
> >>  #endif /* !SELFTEST_KVM_HYPERV_H */
> >> diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> index af27c7e829c1..91d88aaa9899 100644
> >> --- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> +++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
> >> @@ -47,6 +47,7 @@ static void do_wrmsr(u32 idx, u64 val)
> >>  }
> >>
> >>  static int nr_gp;
> >> +static int nr_ud;
> >>
> >>  static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
> >>                             vm_vaddr_t output_address)
> >> @@ -80,6 +81,12 @@ static void guest_gp_handler(struct ex_regs *regs)
> >>                 regs->rip = (uint64_t)&wrmsr_end;
> >>  }
> >>
> >> +static void guest_ud_handler(struct ex_regs *regs)
> >> +{
> >> +       nr_ud++;
> >> +       regs->rip += 3;
> >> +}
> >> +
> >>  struct msr_data {
> >>         uint32_t idx;
> >>         bool available;
> >> @@ -90,6 +97,7 @@ struct msr_data {
> >>  struct hcall_data {
> >>         uint64_t control;
> >>         uint64_t expect;
> >> +       bool ud_expected;
> >>  };
> >>
> >>  static void guest_msr(struct msr_data *msr)
> >> @@ -117,13 +125,26 @@ static void guest_msr(struct msr_data *msr)
> >>  static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
> >>  {
> >>         int i = 0;
> >> +       u64 res, input, output;
> >>
> >>         wrmsr(HV_X64_MSR_GUEST_OS_ID, LINUX_OS_ID);
> >>         wrmsr(HV_X64_MSR_HYPERCALL, pgs_gpa);
> >>
> >>         while (hcall->control) {
> >> -               GUEST_ASSERT(hypercall(hcall->control, pgs_gpa,
> >> -                                      pgs_gpa + 4096) == hcall->expect);
> >> +               nr_ud = 0;
> >> +               if (!(hcall->control & HV_HYPERCALL_FAST_BIT)) {
> >> +                       input = pgs_gpa;
> >> +                       output = pgs_gpa + 4096;
> >> +               } else {
> >> +                       input = output = 0;
> >> +               }
> >> +
> >> +               res = hypercall(hcall->control, input, output);
> >> +               if (hcall->ud_expected)
> >> +                       GUEST_ASSERT(nr_ud == 1);
> >
> > Should we also do WRITE_ONCE(nr_ur, 0) here?
> 
> It could probably make sense to replace 'nr_ud = 0' above with this so
> compiler doesn't screw us up one day..
> 
> > or perhaps pass the the
> > expected value of nr_ud + 1 in hcall->ud_expected from caller and do,
> >
> >     if (hcall->ud_expected)
> >         GUEST_ASSERT(nr_ud == hcall->ud_expected);
> >
> > This way there can be other test that can also expect a UD.
> 
> My idea was that we don't really need to count #UDs for now, just
> checking the fact that it happened is OK so I reset nr_ud before doing
> the hypercall and check it after. It is possible to add more tests with
> 'ud_expected' this way.

Oops, my bad, didn't notice that you were resetting nr_ud before
hypercall(). Thanks for clarifying.

Reviewed-by: Siddharth Chandrasekaran <sidcha@amazon.de>

~ Sid.

> >
> >> +               else
> >> +                       GUEST_ASSERT(res == hcall->expect);
> >> +
> >>                 GUEST_SYNC(i++);
> >>         }
> >>
> >> @@ -552,8 +573,18 @@ static void guest_test_hcalls_access(struct kvm_vm *vm, struct hcall_data *hcall
> >>                         recomm.ebx = 0xfff;
> >>                         hcall->expect = HV_STATUS_SUCCESS;
> >>                         break;
> >> -
> >>                 case 17:
> >> +                       /* XMM fast hypercall */
> >> +                       hcall->control = HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE | HV_HYPERCALL_FAST_BIT;
> >> +                       hcall->ud_expected = true;
> >> +                       break;
> >> +               case 18:
> >> +                       feat.edx |= HV_X64_HYPERCALL_XMM_INPUT_AVAILABLE;
> >> +                       hcall->ud_expected = false;
> >> +                       hcall->expect = HV_STATUS_SUCCESS;
> >> +                       break;
> >> +
> >> +               case 19:
> >>                         /* END */
> >>                         hcall->control = 0;
> >>                         break;
> >> @@ -625,6 +656,10 @@ int main(void)
> >>         /* Test hypercalls */
> >>         vm = vm_create_default(VCPU_ID, 0, guest_hcall);
> >>
> >> +       vm_init_descriptor_tables(vm);
> >> +       vcpu_init_descriptor_tables(vm, VCPU_ID);
> >> +       vm_install_exception_handler(vm, UD_VECTOR, guest_ud_handler);
> >> +
> >>         /* Hypercall input/output */
> >>         hcall_page = vm_vaddr_alloc_pages(vm, 2);
> >>         memset(addr_gva2hva(vm, hcall_page), 0x0, 2 * getpagesize());
> >> --
> >> 2.31.1
> >>
> >
> >
> >
> > Amazon Development Center Germany GmbH
> > Krausenstr. 38
> > 10117 Berlin
> > Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
> > Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
> > Sitz: Berlin
> > Ust-ID: DE 289 237 879
> >
> >
> >
> 
> --
> Vitaly
> 



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



