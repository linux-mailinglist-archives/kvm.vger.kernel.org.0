Return-Path: <kvm+bounces-73188-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IIfDEjlyq2m6dAEAu9opvQ
	(envelope-from <kvm+bounces-73188-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:32:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B16122900D
	for <lists+kvm@lfdr.de>; Sat, 07 Mar 2026 01:32:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5F613305B44F
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2026 00:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4DBD26FA77;
	Sat,  7 Mar 2026 00:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZuG/m4wN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060BD1EB5E1
	for <kvm@vger.kernel.org>; Sat,  7 Mar 2026 00:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772843556; cv=none; b=fuBmiHfCRDVU5LbVlya09fMvwqRxJqSsPvPXiNohWbDGC5naPGtQ/qOqGrg3v3drR0APF/jhvi8dXRSs82d/STYX/oLeiaLMoMduv1tqzG9LccQaym/OB7i4K2sHHPijLK4yah0U3ctXAjrXw+ns8cDA7DPoBUqp3R/P6AnNP08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772843556; c=relaxed/simple;
	bh=U0tv/IWl1t9pY6gIGnpa4aUs8wxrbsgAYa/FtkOyp9E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OLdbv8CoZegR9LJ7bdAkTmTbirUnbRQ8ENzzo2+q2k2xefvjzkEPTBqDkGuEzOTr0QOPMm0986RUU5PZEYxk5UUQD3n0LIbwUnBVaIFXKa4LETb3+PyMZN7lKEaboYLRTezXINpQHjJTznrins4RMAaWSlAShR6TSwfZUPYaOoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZuG/m4wN; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3598518beceso6628828a91.2
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 16:32:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772843554; x=1773448354; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GBuJGZTSukXT+UwxFGKWJrgzhOxt0s7jxcSwbrVM1KQ=;
        b=ZuG/m4wNpiWbnAV/x62Hno3LzDC2bFGGhF8M1DFqaup/8TxDkXu0VIavxnSjYS0ZqP
         G539TEhsj96mQ1E+kHfldU/msKtIaP63RFYOfSREFUcTb51nFyXF9KyMhsGZKm4dbn8N
         +9CShsnF/dd2iWF0ptpYX4grP8z4xK89LtfeQNNXePHOcreYDAXykcwuja7EECz2dTUr
         jjeY73Qq3uK7N9qhRnd5S4vhPIF56/QPto5asO1PdcvJPbX8Xtr2GhRQfVr8QxSFiSWR
         gxwQEscnnn6rBu9LBSX+35Uc6SVImLi4twBb7RmFxWz8Ud3bYcxc/ggRXw5l1bBKWO7/
         SBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772843554; x=1773448354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GBuJGZTSukXT+UwxFGKWJrgzhOxt0s7jxcSwbrVM1KQ=;
        b=i7csXoQgoy/ZORKnBtZR7LjveCXjtHyNwn+za2CNumrY2BYdfdH8rM4lBSkqLBBiTe
         mj69Ofrc47R1ZeHlg0P0TvVoNR7FqKgGZ3A89QQMWxBD4vGwS6P68ATUsezfiHfx2D72
         tQ9h7HS7HTfesxcCIpvn2wAcXukwcLr2yb9of+4KoKHP0A+xRzsfguwq0NvZDb/zSZW9
         kHT53oZGSW8oCqZu2KynwKjOSBTB98XW5ZkADbnP01jv7h1oPYJ7wzrrVgC8ofHcz7jR
         kb3vwHgq+4gkzHK9qm9L1uFQPRKl51/T0K5eFy/7XVfNZObIMBWwVGo7pxwLl6XyfUTI
         zUQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXw3Cx0/BwHyGBzU6RUuv37F9odk7tDb9Y+L8n4AaBusuwfDQfHam5ugEIKC2QEcCMTg4c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhHOh5HNvxF+5+diw2hI5lIkYURIT8ttWaOBJ4Fy9cfbGW/7qL
	agWXXCq4CxWP+C9K/WzR7OMCoW64sC0F1Ho+TSmilkv2Rsi8mKfTwQJ1edcuKgFi680VLW6hCeh
	ESkgTNg==
X-Received: from pjtn10.prod.google.com ([2002:a17:90a:c68a:b0:358:e8ed:94e4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:28d0:b0:33b:b078:d6d3
 with SMTP id 98e67ed59e1d1-359be314eb6mr3520595a91.23.1772843554253; Fri, 06
 Mar 2026 16:32:34 -0800 (PST)
Date: Fri, 6 Mar 2026 16:32:32 -0800
In-Reply-To: <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306210900.1933788-1-yosry@kernel.org> <20260306210900.1933788-2-yosry@kernel.org>
 <CALMp9eRWwPwUSyQmizy8i2tF1CVO4iLY6x0vX1OoPUiRdCm4NQ@mail.gmail.com>
 <CAO9r8zOhaDeYWq_6TNdPGyEE323o_8xsWTozGdro9Oni8310kA@mail.gmail.com>
 <CALMp9eScswzFak+PMOcaDXM-W+cXtkG7fQ=jadq__+5JeqYcTQ@mail.gmail.com> <CAO9r8zOK5+xmkf3FsWRz2wHcUCN30GJ9kfZx-K7DAa1HNGhRVA@mail.gmail.com>
Message-ID: <aatyIPwz9ePKdzJx@google.com>
Subject: Re: [PATCH v2 1/6] KVM: SVM: Use maxphyaddr in emulator RAX check for VMRUN/VMLOAD/VMSAVE
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 9B16122900D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73188-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.948];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026, Yosry Ahmed wrote:
> > > Right, but I am trying to have the #GP check for VMLOAD/VMSAVE behave
> > > consistently with vls=1, whether it's done by the hardware or the
> > > emulator.
> >
> > Consistency should not be an issue, since VLS cannot be enabled when
> > the MAXPHYADDRs differ. VLS doesn't work in that scenario.
> 
> Why? It's only broken if VMLOAD/VMSAVE is executed with a GPA that
> exceeds the guest's MAXPHYADDR, but not the host's, right? So only
> broken if the guest is misbehaving.
> 
> Taking a step back, I am not disagreeing that VLS should not be used
> with different MAXPHYADDRs, I am just saying it might be.

KVM straight up doesn't support that (see my other reply).

> All that being said, I am fine with using cpuid_maxphyaddr(vcpu)
> instead of kvm_host.maxphyaddr. Will wait for Sean's feedback to
> figure out if a new version is needed.

LOL, Jim and I are of one mind when it comes to guest.MAXPHYADDR.

