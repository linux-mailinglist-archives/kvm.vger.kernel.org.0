Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEE4D1CFC25
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 19:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgELR2D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 May 2020 13:28:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:18465 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgELR2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 May 2020 13:28:02 -0400
IronPort-SDR: fpHXy++5fyEYManVvpGTOvRbms5B132QQYeHksVALRsYKAPAtdl9JrL5jY2AE0zf1S0AN0bscG
 Q9cL+qevXM1w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2020 10:28:01 -0700
IronPort-SDR: mp2rj3uAt55q5WHrbIIQcB7PSgrbm7VVL6xmMNNGZCJTIYRl4kjU9B0QvhTmrAe0iSL43+VyQa
 Syy0RXQ0J4oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,384,1583222400"; 
   d="scan'208";a="463834390"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 12 May 2020 10:28:01 -0700
Date:   Tue, 12 May 2020 10:28:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Babu Moger <babu.moger@amd.com>, Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        mchehab+samsung@kernel.org, changbin.du@intel.com,
        Nadav Amit <namit@vmware.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        yang.shi@linux.alibaba.com,
        Anthony Steinhauser <asteinhauser@google.com>,
        anshuman.khandual@arm.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        steven.price@arm.com, rppt@linux.vnet.ibm.com, peterx@redhat.com,
        Dan Williams <dan.j.williams@intel.com>,
        Arjun Roy <arjunroy@google.com>, logang@deltatee.com,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com,
        Kees Cook <keescook@chromium.org>,
        Juergen Gross <jgross@suse.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        pawan.kumar.gupta@linux.intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] KVM: x86: Move MPK feature detection to common
 code
Message-ID: <20200512172800.GB12100@linux.intel.com>
References: <158923982830.20128.14580309786525588408.stgit@naples-babu.amd.com>
 <158923999440.20128.4859351750654993810.stgit@naples-babu.amd.com>
 <CALMp9eTs4hYpDK+KzXEzaAptcfor+9f7cM9Yd9kvd5v27sdFRw@mail.gmail.com>
 <2fb5fd86-5202-f61b-fd55-b3554c5826da@amd.com>
 <CALMp9eRT69LWGE8dZVuLv2mxgc_R3W1SnPswHkhS8K0ZUX_B-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eRT69LWGE8dZVuLv2mxgc_R3W1SnPswHkhS8K0ZUX_B-Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 12, 2020 at 09:58:19AM -0700, Jim Mattson wrote:
> On Tue, May 12, 2020 at 8:12 AM Babu Moger <babu.moger@amd.com> wrote:
> >
> >
> >
> > On 5/11/20 6:51 PM, Jim Mattson wrote:
> > > On Mon, May 11, 2020 at 4:33 PM Babu Moger <babu.moger@amd.com> wrote:
> > >>
> > >> Both Intel and AMD support (MPK) Memory Protection Key feature.
> > >> Move the feature detection from VMX to the common code. It should
> > >> work for both the platforms now.
> > >>
> > >> Signed-off-by: Babu Moger <babu.moger@amd.com>
> > >> ---
> > >>  arch/x86/kvm/cpuid.c   |    4 +++-
> > >>  arch/x86/kvm/vmx/vmx.c |    4 ----
> > >>  2 files changed, 3 insertions(+), 5 deletions(-)
> > >>
> > >> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > >> index 901cd1fdecd9..3da7d6ea7574 100644
> > >> --- a/arch/x86/kvm/cpuid.c
> > >> +++ b/arch/x86/kvm/cpuid.c
> > >> @@ -278,6 +278,8 @@ void kvm_set_cpu_caps(void)
> > >>  #ifdef CONFIG_X86_64
> > >>         unsigned int f_gbpages = F(GBPAGES);
> > >>         unsigned int f_lm = F(LM);
> > >> +       /* PKU is not yet implemented for shadow paging. */
> > >> +       unsigned int f_pku = tdp_enabled ? F(PKU) : 0;
> > >
> > > I think we still want to require that OSPKE be set on the host before
> > > exposing PKU to the guest.
> > >
> >
> > Ok I can add this check.
> >
> > +       unsigned int f_pku = tdp_enabled && F(OSPKE)? F(PKU) : 0;
> 
> That doesn't do what you think it does. F(OSPKE) is a non-zero
> constant, so that conjunct is always true.

My vote would be to omit f_pku and adjust the cap directly, e.g.

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 6828be99b9083..998c902df9e57 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -326,7 +326,7 @@ void kvm_set_cpu_caps(void)
        );

        kvm_cpu_cap_mask(CPUID_7_ECX,
-               F(AVX512VBMI) | F(LA57) | 0 /*PKU*/ | 0 /*OSPKE*/ | F(RDPID) |
+               F(AVX512VBMI) | F(LA57) | F(PKU) | 0 /*OSPKE*/ | F(RDPID) |
                F(AVX512_VPOPCNTDQ) | F(UMIP) | F(AVX512_VBMI2) | F(GFNI) |
                F(VAES) | F(VPCLMULQDQ) | F(AVX512_VNNI) | F(AVX512_BITALG) |
                F(CLDEMOTE) | F(MOVDIRI) | F(MOVDIR64B) | 0 /*WAITPKG*/
@@ -334,6 +334,8 @@ void kvm_set_cpu_caps(void)
        /* Set LA57 based on hardware capability. */
        if (cpuid_ecx(7) & F(LA57))
                kvm_cpu_cap_set(X86_FEATURE_LA57);
+       if (!tdp_enabled || !boot_cpu_has(OSPKE))
+               kvm_cpu_cap_clear(X86_FEATURE_PKU);

        kvm_cpu_cap_mask(CPUID_7_EDX,
                F(AVX512_4VNNIW) | F(AVX512_4FMAPS) | F(SPEC_CTRL) |
