Return-Path: <kvm+bounces-44798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AE09AA1054
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 17:22:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AD817AA226
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 15:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38A4122128A;
	Tue, 29 Apr 2025 15:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YSWjDd86"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD622206A2
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745940124; cv=none; b=AcdlR8rIFm1fzTvHNZFTBBCCtEbTBzWqsorfVaGWkCYRiJ4wqgZs5gvOGjWG56l08tw2JmyxeaC2YSvINMbaujA5qhpcUWDCiKGYVRtC5TjriYKsG61He4DjpEWXvaTs+egzJPsjk/coGScabuypdE5Jn7ZAAepY0TKppCMfA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745940124; c=relaxed/simple;
	bh=eTm8uUOjEA2yj6gyEF2Wj5Q6fv0haX5JFNB0Clpjs/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UoTKiC/Zqk88184TmorSdttLy9gMDlDVy/7yBj8ENZACl937TW+swWzRxvDWIntoAiSCv7f2iNx0cYzqLEio9eT/1jlp6ZWRTtW2OktbmTQt2SYmtDDsJCEFtsghv3a6ypkJ/aBWLFDPjF3HxMq7DIMEeosXKHpQ9JHGYAShuVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YSWjDd86; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff8340d547so5138270a91.2
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 08:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745940122; x=1746544922; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aNk7xuT0f0Cef+C938NHaMgqXngD7O4h38pLZxapbNs=;
        b=YSWjDd86r2ThzV3EF7G4IMgG5Fb2415C5I2rotOspfhWTRxA0vJ37hxPYZHe4gw+wa
         i6kXHbcEfaiKwnlX8dEo4UAmmzGUBBf29LHYYZ06LpFvnK7WKroeLpQ83muEB0to6wRV
         lPI6pcGwOhcOadlGmtBWqFUkIJFbQfCotZQFQAi9Y0lH8x8q1d015+Izhjrc6tSVoOJL
         tFxtivNGgHNsMnn9r3DTMX7VAS+QFPrOZghls354S5w+RF5afgnUxHqtbi6BPGGFpBwC
         zhuRqqjWRdhC9qhYLn3vzyNyY5wQIaSJsg9NZ7KND6rgDpYQxIX10hHkud2pnrPord1A
         wlWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745940122; x=1746544922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aNk7xuT0f0Cef+C938NHaMgqXngD7O4h38pLZxapbNs=;
        b=mpTgU1jIyGwM3/zwRAIK5v4ZN0762F3kn7Wu9xq++ENLnFCVuQSXlBIfk9rZsQwrgv
         lRYB7MiA/sB7+paflXqwGkbji6gsH8AzX/unYwCnAXz/zxSGIwrjmkTp7YlqoLi2bJhd
         xEJmhEtdlNyq9qqr2bagtfkXO5stZC6rl+4Vm4iI4+88A+eOUbF0/bEUqWORb5BJpxq2
         g22DxZLBwsm+MrTI29ux+p/Gvo5hMIOt6RxufFSuAeKdwyFyPk4PFWkAkF+rktSdPj8k
         VMCZNcC9ohF3v9rGKLiWND+VFjHz7DDaET9mtD7yjMKEhqbKNRmIS0VzNCwyp7bqUZOp
         xMRg==
X-Gm-Message-State: AOJu0YwYROrcS/tUybzZ1iv6C8GZt7PdlVKjf1lecqORaCtSI02sOcp/
	MvkbBldDeDhLeO/xwa8tfKqVoto6MdKaqh5FFLuTvxWlORPZU4ipaSe8shbFz25ourl6ruWDF8d
	5RA==
X-Google-Smtp-Source: AGHT+IFYXh1I3s4XEFN65uVfk6oHWBn6YIlt2ZFbuISXBnP3zzgosLfAG8nouUaaQl7BdvugXwDdfe4pOcI=
X-Received: from pjbsg5.prod.google.com ([2002:a17:90b:5205:b0:2f2:e97a:e77f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e4b:b0:2ff:64c3:3bd9
 with SMTP id 98e67ed59e1d1-30a0139a0b8mr15921485a91.23.1745940122452; Tue, 29
 Apr 2025 08:22:02 -0700 (PDT)
Date: Tue, 29 Apr 2025 08:22:00 -0700
In-Reply-To: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8f03878443681496008b1b37b7c4bf77a342b459.1745866531.git.thomas.lendacky@amd.com>
Message-ID: <aBDumDW9kWEotu0A@google.com>
Subject: Re: [PATCH] KVM: SVM: Update dump_ghcb() to use the GHCB snapshot fields
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Apr 28, 2025, Tom Lendacky wrote:
> @@ -3184,18 +3189,18 @@ static void dump_ghcb(struct vcpu_svm *svm)
>  		return;
>  	}
>  
> -	nbits = sizeof(ghcb->save.valid_bitmap) * 8;
> +	nbits = sizeof(svm->sev_es.valid_bitmap) * 8;

I'm planning on adding this comment to explain the use of KVM's snapshot.  Please
holler if it's wrong/misleading in any way.

	/*
	 * Print KVM's snapshot of the GHCB that was (unsuccessfully) used to
	 * handle the exit.  If the guest has since modified the GHCB itself,
	 * dumping the raw GHCB won't help debug why KVM was unable to handle
	 * the VMGEXIT that KVM observed.
	 */

>  	pr_err("GHCB (GPA=%016llx):\n", svm->vmcb->control.ghcb_gpa);
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_code",
> -	       ghcb->save.sw_exit_code, ghcb_sw_exit_code_is_valid(ghcb));
> +	       kvm_ghcb_get_sw_exit_code(control), kvm_ghcb_sw_exit_code_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_1",
> -	       ghcb->save.sw_exit_info_1, ghcb_sw_exit_info_1_is_valid(ghcb));
> +	       control->exit_info_1, kvm_ghcb_sw_exit_info_1_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_exit_info_2",
> -	       ghcb->save.sw_exit_info_2, ghcb_sw_exit_info_2_is_valid(ghcb));
> +	       control->exit_info_2, kvm_ghcb_sw_exit_info_2_is_valid(svm));
>  	pr_err("%-20s%016llx is_valid: %u\n", "sw_scratch",
> -	       ghcb->save.sw_scratch, ghcb_sw_scratch_is_valid(ghcb));
> -	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, ghcb->save.valid_bitmap);
> +	       svm->sev_es.sw_scratch, kvm_ghcb_sw_scratch_is_valid(svm));
> +	pr_err("%-20s%*pb\n", "valid_bitmap", nbits, svm->sev_es.valid_bitmap);
>  }

