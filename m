Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 134E3199966
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 17:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730541AbgCaPPt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 11:15:49 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52835 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730153AbgCaPPt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 11:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585667745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m8+3d5vMc5xXWDa7fXaBAPyVjMxuViNicYWTi09jWTk=;
        b=fIFjzCnRvAOxljyNbEL/1gLndhWaGLYZ+KEc5LHiHvpFvl7RfFWwiBLdc6Wfyb9S2oHbP5
        ynk81HuobDLRtDZgqhDXv8gc9P1xRkC7AACXaWwa/zx7r1s89vKPI2CVUInSizWMq/KHkD
        uNJP8hE51uzySIMnXubeC7MkEn/lLs8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-438--OS3LElBMvGahmvu-Qz3mQ-1; Tue, 31 Mar 2020 11:15:43 -0400
X-MC-Unique: -OS3LElBMvGahmvu-Qz3mQ-1
Received: by mail-wr1-f71.google.com with SMTP id e10so13202127wrm.2
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 08:15:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m8+3d5vMc5xXWDa7fXaBAPyVjMxuViNicYWTi09jWTk=;
        b=kgQPLSqvj0+gQnR/Le6IglJz40ZcR8g+MDyTxhwOoVxj3587pKd9NGr5OQhtqeemtd
         8tr32NJfyqHvzbpk/SOoPp43zUqJxRe8ShRRWXJrJyBs4YTkZBwk6GF6aQCwcycd/fMV
         a5FKt+XEBCz++B8fYLpoGkLKgcUvRVjx9eJxRvWHOPOKDZZ5ZOlGPYXPQ9GxkPucnGcm
         KNJEM3GlNPZuyaf9cP6Gh5gSO87f+ZQTSnPP50RnD7I3VMr4+M7LXWFLZlUe+oDq2Kud
         7pmxDoqEvfeppka6kZUWukiE5FhfiZAL9QMB8E9QPsywcVv4vgHY28HOLJsqaYshAKFW
         xZlA==
X-Gm-Message-State: ANhLgQ0pIIfuQwT8ekSnXOT3O9YtC6zVhYq0gmxrKw5bczJbRwXoU9Y1
        jhXg9B4gq5geTS+k4gA6dry6DrL8WBtkH8oRKAz7kgzjJqOqR9D/3iaww1KeqaNE1mPcUuiZe/q
        vHLXG2Lq3p7jA
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr19806602wrw.281.1585667741978;
        Tue, 31 Mar 2020 08:15:41 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vs04fIKv1m157X1qSL2NhAtmgEXMr4wv4wC9BBMdokgI5X+G4/Md6oITky83Web8rxYKoGb+g==
X-Received: by 2002:a05:6000:1090:: with SMTP id y16mr19806572wrw.281.1585667741679;
        Tue, 31 Mar 2020 08:15:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b55d:5ed2:8a41:41ea? ([2001:b07:6468:f312:b55d:5ed2:8a41:41ea])
        by smtp.gmail.com with ESMTPSA id z3sm4024153wma.22.2020.03.31.08.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 08:15:41 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH] x86: access: Shadow CR0, CR4 and EFER to
 avoid unnecessary VM-Exits
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org
References: <20200310035432.3447-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8ff42509-c57b-5f22-777f-516693a1e2b9@redhat.com>
Date:   Tue, 31 Mar 2020 17:15:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310035432.3447-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/03/20 04:54, Sean Christopherson wrote:
> Track the last known CR0, CR4, and EFER values in the access test to
> avoid taking a VM-Exit on every. single. test.  The EFER VM-Exits in
> particular absolutely tank performance when running the test in L1.
> 
> Opportunistically tweak the 5-level test to print that it's starting
> before configuring 5-level page tables, e.g. in case enabling 5-level
> paging runs into issues.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  x86/access.c | 45 +++++++++++++++++++++++++++------------------
>  1 file changed, 27 insertions(+), 18 deletions(-)
> 
> diff --git a/x86/access.c b/x86/access.c
> index 7303fc3..86d8a72 100644
> --- a/x86/access.c
> +++ b/x86/access.c
> @@ -169,29 +169,33 @@ typedef struct {
>  
>  static void ac_test_show(ac_test_t *at);
>  
> +static unsigned long shadow_cr0;
> +static unsigned long shadow_cr4;
> +static unsigned long long shadow_efer;
> +
>  static void set_cr0_wp(int wp)
>  {
> -    unsigned long cr0 = read_cr0();
> -    unsigned long old_cr0 = cr0;
> +    unsigned long cr0 = shadow_cr0;
>  
>      cr0 &= ~CR0_WP_MASK;
>      if (wp)
>  	cr0 |= CR0_WP_MASK;
> -    if (old_cr0 != cr0)
> +    if (cr0 != shadow_cr0) {
>          write_cr0(cr0);
> +        shadow_cr0 = cr0;
> +    }
>  }
>  
>  static unsigned set_cr4_smep(int smep)
>  {
> -    unsigned long cr4 = read_cr4();
> -    unsigned long old_cr4 = cr4;
> +    unsigned long cr4 = shadow_cr4;
>      extern u64 ptl2[];
>      unsigned r;
>  
>      cr4 &= ~CR4_SMEP_MASK;
>      if (smep)
>  	cr4 |= CR4_SMEP_MASK;
> -    if (old_cr4 == cr4)
> +    if (cr4 == shadow_cr4)
>          return 0;
>  
>      if (smep)
> @@ -199,37 +203,39 @@ static unsigned set_cr4_smep(int smep)
>      r = write_cr4_checking(cr4);
>      if (r || !smep)
>          ptl2[2] |= PT_USER_MASK;
> +    if (!r)
> +        shadow_cr4 = cr4;
>      return r;
>  }
>  
>  static void set_cr4_pke(int pke)
>  {
> -    unsigned long cr4 = read_cr4();
> -    unsigned long old_cr4 = cr4;
> +    unsigned long cr4 = shadow_cr4;
>  
>      cr4 &= ~X86_CR4_PKE;
>      if (pke)
>  	cr4 |= X86_CR4_PKE;
> -    if (old_cr4 == cr4)
> +    if (cr4 == shadow_cr4)
>          return;
>  
>      /* Check that protection keys do not affect accesses when CR4.PKE=0.  */
> -    if ((read_cr4() & X86_CR4_PKE) && !pke) {
> +    if ((shadow_cr4 & X86_CR4_PKE) && !pke)
>          write_pkru(0xfffffffc);
> -    }
>      write_cr4(cr4);
> +    shadow_cr4 = cr4;
>  }
>  
>  static void set_efer_nx(int nx)
>  {
> -    unsigned long long efer = rdmsr(MSR_EFER);
> -    unsigned long long old_efer = efer;
> +    unsigned long long efer = shadow_efer;
>  
>      efer &= ~EFER_NX_MASK;
>      if (nx)
>  	efer |= EFER_NX_MASK;
> -    if (old_efer != efer)
> +    if (efer != shadow_efer) {
>          wrmsr(MSR_EFER, efer);
> +        shadow_efer = efer;
> +    }
>  }
>  
>  static void ac_env_int(ac_pool_t *pool)
> @@ -245,7 +251,7 @@ static void ac_env_int(ac_pool_t *pool)
>  
>  static void ac_test_init(ac_test_t *at, void *virt)
>  {
> -    wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_NX_MASK);
> +    set_efer_nx(1);
>      set_cr0_wp(1);
>      at->flags = 0;
>      at->virt = virt;
> @@ -935,14 +941,17 @@ static int ac_test_run(void)
>      printf("run\n");
>      tests = successes = 0;
>  
> +    shadow_cr0 = read_cr0();
> +    shadow_cr4 = read_cr4();
> +    shadow_efer = rdmsr(MSR_EFER);
> +
>      if (this_cpu_has(X86_FEATURE_PKU)) {
>          set_cr4_pke(1);
>          set_cr4_pke(0);
>          /* Now PKRU = 0xFFFFFFFF.  */
>      } else {
> -	unsigned long cr4 = read_cr4();
>  	tests++;
> -	if (write_cr4_checking(cr4 | X86_CR4_PKE) == GP_VECTOR) {
> +	if (write_cr4_checking(shadow_cr4 | X86_CR4_PKE) == GP_VECTOR) {
>              successes++;
>              invalid_mask |= AC_PKU_AD_MASK;
>              invalid_mask |= AC_PKU_WD_MASK;
> @@ -996,8 +1005,8 @@ int main(void)
>  
>      if (this_cpu_has(X86_FEATURE_LA57)) {
>          page_table_levels = 5;
> -        setup_5level_page_table();
>          printf("starting 5-level paging test.\n\n");
> +        setup_5level_page_table();
>          r = ac_test_run();
>      }
>  
> 

Applied all three patches, thanks.

Paolo

