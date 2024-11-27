Return-Path: <kvm+bounces-32604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BCFE29DAE99
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 21:43:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81E5F28277A
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 20:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1D4202F93;
	Wed, 27 Nov 2024 20:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tmKApume"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E778514AD29
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 20:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732740206; cv=none; b=oPKFol/61qzowRygE2twy8bwAZ54bwD+eSEc9BXYxAOx/S3Gu0WHNThQ+AL52uyCUR2Y5gPU+1RmdoFRTEF9pMaaTPZqcg1YCs/fd6TFNdK5uuOiBtQRJmv0CJL3hrhojqfDeKTDwxe713NoUQb9SB9ZB/ODGBfiNj8Kaqk4RPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732740206; c=relaxed/simple;
	bh=F2EZxrgxL/nac3ILjVMuqC1ozBySHYBQpX+yUm2ruiA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CHvP4umMgLbzrmF2vuahv/KgGZjSVyxSBUm0oqh7ncllxhkGWcsefzbCW0zgFEpeFLZtf6metDgCG5j+VX0YBGKnf/okkSSlXVwZ+gT/mevfdNYKXsi8uVXvHea42BC86+EurEv5BD0f+5iiAm6ESzNwyH+7TH6neIOEcoajoDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tmKApume; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea33ae82efso156074a91.3
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 12:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732740204; x=1733345004; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=OAQtm+DzMCe0wVJdzwyW/tJS1xJ6PF2eJiYRB9lhQaE=;
        b=tmKApumeVAuJOWdWx3gZYGteTAmqZxbsyttEBPsqQw+18hpoGXP7qDL3cziGSRVHJr
         9ieUm5GKa8sa3s0H5vP7qLY13kIwrOGR0tQlg+kypn1uR3ZjywIv/CINaNl+k++ocXNp
         jzrvH2A4OWN/QOT+pbDWYYpM+i9YYAl7TZJK3iH+2vXkGmOfNlzp8XqcQqj+PX25Ea7I
         Osu7WYWwqyCa29DSiyPJFY7/YlA5GMRlbZ1nqcxroXvqyTxsNbcsxtft4zVXfKLueuH+
         wIuFzW+ylmABTytMwPBC9mZtALePOI19n/2+phnyCQ1cLV+hrptWSzyEsmHBsypCALeV
         HxsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732740204; x=1733345004;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OAQtm+DzMCe0wVJdzwyW/tJS1xJ6PF2eJiYRB9lhQaE=;
        b=fAwpyfku+w3v+9gJHbVCHuy8/e9LqwVZeqoeNCqzr7EN7Xhvl1w0IAZPzGokjx9lzC
         onxyCSuBVW6IjvQIf8xQ37b75zX1E+DpMimQzwy1CUXMzHmjyOqak0AsMaJk8XkC+X+x
         CisHCpaoqomsnU9bhUYHGzQBxZXKrry76TLrE4YMILXicFXdzOEJ/O/CHMaa43Hk+E5b
         zMcu17v2laXNxr9LJTykEc8N5uSyEzhJ8RngyaPKJZKCSkUzEnwcOIsXnCSSe62pD6jz
         XVl/Lm/cS8AX52kjvHTeTQbgXRvsEVksiNukima6tAdarGAibGZ2/tvv7CkgyiQ1pLQs
         RmGA==
X-Gm-Message-State: AOJu0Yz+hPDUkFQr+mPrCmkr0k6eEwLL4SsCZCvwylkoe1G2gT2JZgPO
	B61Ouc7qFXUtDPqZ1kBWIHEL3LlWw8TQEJAjvA1ipjKBkpocSU6+WELvYUBX5Ca+SV5KQG6oYl0
	6pg==
X-Google-Smtp-Source: AGHT+IFXwYw/ZkSXkiNwM9sGOgbaSbVQhSJygu2AQj4H8FT8+cTZWapalWpWbePdJz80hQXwSVpHpeNQWNs=
X-Received: from pjbsi15.prod.google.com ([2002:a17:90b:528f:b0:2ea:b0c1:7053])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c45:b0:2ea:9309:759f
 with SMTP id 98e67ed59e1d1-2ee08e5caa0mr5673537a91.1.1732740204139; Wed, 27
 Nov 2024 12:43:24 -0800 (PST)
Date: Wed, 27 Nov 2024 12:43:22 -0800
In-Reply-To: <20241127201929.4005605-6-aaronlewis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241127201929.4005605-1-aaronlewis@google.com> <20241127201929.4005605-6-aaronlewis@google.com>
Message-ID: <Z0eEajZtBDvsUyYc@google.com>
Subject: Re: [PATCH 05/15] KVM: x86: SVM: Adopt VMX style MSR intercepts in SVM
From: Sean Christopherson <seanjc@google.com>
To: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com, 
	Anish Ghulati <aghulati@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 27, 2024, Aaron Lewis wrote:
> VMX MSR interception is done via three functions:
> 
>         vmx_disable_intercept_for_msr(vcpu, msr, type)
>         vmx_enable_intercept_for_msr(vcpu, msr, type)
>         vmx_set_intercept_for_msr(vcpu, msr, type, value)
> 
> While SVM uses
> 
>         set_msr_interception(vcpu, msrpm, msr, read, write)
> 
> The SVM code is not very intuitive (using 0 for enable and 1 for
> disable), and forces both read and write changes with each call which
> is not always required.
> 
> Add helpers functions to SVM to match VMX:
> 
>         svm_disable_intercept_for_msr(vcpu, msr, type)
>         svm_enable_intercept_for_msr(vcpu, msr, type)
>         svm_set_intercept_for_msr(vcpu, msr, type, enable_intercept)
> 
> Additionally, update calls to set_msr_interception() to use the new
> functions. This update is only made to calls that toggle interception
> for both read and write.
> 
> Keep the old paths for now, they will be deleted once all code is
> converted to the new helpers.
> 
> Opportunistically, the function svm_get_msr_bitmap_entries() is added
> to abstract the MSR bitmap from the intercept functions.  This will be
> needed later in the series when this code is hoisted to common code.
> 
> No functional change.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Co-Developed-by: Anish Ghulati <aghulati@google.com>

Needs Anish's SoB.

> Signed-off-by: Aaron Lewis <aaronlewis@google.com>

