Return-Path: <kvm+bounces-7749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EDCA845E0B
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9CE61F2DBDD
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D068B5E227;
	Thu,  1 Feb 2024 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gvtpEJn4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57DE5E20C
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706806941; cv=none; b=kthpWYbH++Epw2yeFiDcuw685/wHVFpskFroRRRcynSsIv+a/QpY507dXfbrHYHLjIjkryJKLlRRCWRmpKEsV8dO1EaCfXYcIEJGyHRytHOEvoKavQ1PC9M892rHfZkAU0oFvn4UvO/um/vqXQc90g44AvgmioQ/9RogbYInemM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706806941; c=relaxed/simple;
	bh=c4p9DobmpE1sqkx+92AWIdugq3y/UU+fZrmKgJ1fn/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=vDrS1soufASNJp9LELyQa9MBV0WoRZ6xrDK/fjpHHZY4HPMtXV1TJo731UDbhvEka0Q6BxVi/mxkcRGgbFtfQpAFXcOoMHdImcDkqiLB81nVk35xzNfxKZGOZRoqo9RaIyB218UV2lPEUD/X5Y2bG2rbE4Gi+Pk4bu5Ctv4CSvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gvtpEJn4; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5d8df7c5500so746010a12.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 09:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706806939; x=1707411739; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9XgZgs1yo7sLg4oN+/Ob+0HqugSuGej5jfcgiqE+nLA=;
        b=gvtpEJn4AqcsQxF2Nh3EeRQTUil/loB4P/zYHhg0OZr6fccJF+CreLj0dqSR3bVReK
         4ql/JA2OxObMk9wToAQAPIOrL24hSr/ytUb7LATq/5ozIEE4OJJQ13wv1pqzlZ3wuMsm
         fezgR9jtghPn5U2keWg+3B9BeEXZ3PA/Pz3+IhUPk26Z7iPXH6SPdqa7MUUicB1hw9SQ
         fKbJyyKbcl+TXb8OJY2/mwzVp+KV5NtDdIPs/6DufiMJw92JMhwJPjW66PT7G35Hy75G
         LrBnqlE/DgE3cIrOx2m/EcOxaDN1HmziXIFDx3FDNZ9hSoISfTwt50vTLGvYJLa3JMfl
         O/3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706806939; x=1707411739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XgZgs1yo7sLg4oN+/Ob+0HqugSuGej5jfcgiqE+nLA=;
        b=Q84Esy93Xxfu83TzKBN972o/6IMZFi+KRFOhNLw3uqY69AxeKl6M2iuWRxxKUgb1Y/
         md4sKU+x6v0drUlAhmADP7fh3bBMM8m7ZFrz9Zx3rKh5Y4p6eh6hlO3m9XAIXp4RBqNA
         ACzzPSGpWPDQXMWUUsgb+HT2J8LCWJGXH97qRRWNRXoOjRmqvmpt6LDMkGDtkpb6tOQP
         CQ9T6kXC+vsmFptRH8NbhsUnEG0WKcAJpfLeAKgcX7SMJ/p/om1/JPSVoOerNo2qp1vb
         TL1Na7OAPe+3BbMtCCdE1gKqXOrlH3Rks2pA4nDeu50sY1WSJzKjrxKF0LSF+rzea8Ww
         7UeA==
X-Gm-Message-State: AOJu0YxgDD/o6zV8+YwXUH1k3Cno5liHLbP4UUgfLBjeOEDDiuxAduMj
	OHGjqbUMn4ga1CxIOuqLxFhyMqRs3234bpzlIhgoy8PYGk5rUgy39vmca7y5XGnPuYvjgaj6SXr
	5ug==
X-Google-Smtp-Source: AGHT+IEaikIn2YhXVYoFeVO3SYYkY8p4Mg0gUqK9fC889kBrgk+LpDGNwzdIRVwtOCQJgQrI4QmqJKn4TQs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:6844:0:b0:5d8:c0fa:c982 with SMTP id
 q4-20020a656844000000b005d8c0fac982mr32445pgt.10.1706806938898; Thu, 01 Feb
 2024 09:02:18 -0800 (PST)
Date: Thu, 1 Feb 2024 09:02:17 -0800
In-Reply-To: <7d74cea0-2d98-476b-8d55-ec3a4e3c0fc7@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240131235609.4161407-1-seanjc@google.com> <20240131235609.4161407-3-seanjc@google.com>
 <7d74cea0-2d98-476b-8d55-ec3a4e3c0fc7@amd.com>
Message-ID: <ZbvOmf8N-tLOr-0r@google.com>
Subject: Re: [PATCH v4 2/4] KVM: SVM: Use unsigned integers when dealing with ASIDs
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 01, 2024, Tom Lendacky wrote:
> On 1/31/24 17:56, Sean Christopherson wrote:
> > @@ -2312,7 +2314,7 @@ int sev_cpu_init(struct svm_cpu_data *sd)
> >    */
> >   static void sev_flush_encrypted_page(struct kvm_vcpu *vcpu, void *va)
> >   {
> > -	int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
> > +	unsigned int asid = to_kvm_svm(vcpu->kvm)->sev_info.asid;
> 
> Since you're touching this, you could switch this to:
> 
> 	unsigned int asid = sev_get_asid(vcpu->kvm);

Ah, good call, will do when applying.

Thanks!

