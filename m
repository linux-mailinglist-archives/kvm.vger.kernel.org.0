Return-Path: <kvm+bounces-21422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F45692EC5E
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 18:11:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B9BB1F24C63
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2024 16:11:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A77B616CD17;
	Thu, 11 Jul 2024 16:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3v87nGQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858FE16B38E
	for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720714287; cv=none; b=OvMe00v+uF7V0AmLGAXsgLN6XCAzLNKxRdeWQOOJR4gfVWpV3DyrGNd3NFMoJY+V/f9q2MYDV81h8pLVC0dKV7fHc67yjEpT1T3aricwFM0bhqufW3Y5tSzdbRSATB77l9B/haqd/2QIVg16K3jrP5KyK+utdzySuAJhn0K6Dug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720714287; c=relaxed/simple;
	bh=v/Q/FkYQWlP5mhjRIjT1FY0WOityzEUvvrsfXcoTSMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lG5Mln4iQkGyQhiseM+EXVoc5LoogzxEuqFxUQuONP6PAwPs4CkN5arTwtPsFk0sRHGX2HIoQRVzls85tyJzZxf5aSwjAYomU4Kyp5W7bUZdBdxdnmt6Cvc9VddQIsVAZWYsG4rUQ4JyNXS7Jc4183Zu+tQvB/YAZJ5EOqUbz00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3v87nGQ; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-58ce966a1d3so14775a12.1
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2024 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720714285; x=1721319085; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s55DGZEOMg9QZyntspE5hZ/WZzvStwyhAiZPOpnNBOw=;
        b=y3v87nGQ8GNXpOfw3nPsFkObYSPF3YmtCfdX3ng07LOkc63BtvoZK6RI9l3jKTjoW1
         LjnR2QPCODB6tVUsLzV2XsvsTNbbo03XnNf2L0MjWWQGcnLE6s75J4cNn5bt1sYVeuQ4
         CJ3csHfajMLkqHjLtg0Ncy3+nCeMQ7Ty+UlhPE5sHyNtIqEvm971xaLiaCjd19r3YolY
         Zij2fIu5soRQWUC3UZYkPL4ZOkTEZzThjfGIFGepmywfQJ53ONKajc8UMiEoYr+XH/sA
         MPwnLfyQY3MU1s2MdEmrLCKrcas9Rgk9zvJu6mERC0+SS4O/RwocUpakd6KQt7WsK5KH
         AZYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720714285; x=1721319085;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s55DGZEOMg9QZyntspE5hZ/WZzvStwyhAiZPOpnNBOw=;
        b=sn54nYSll14M4/yFnEhReCxBXEtwD/xvTVGSNNMSFAvMZBzwAv3X8xo+vIfFVpgLve
         4S50CYtmqOCv/rKvOpQk1BmLaCsd12KjOKGmZDd+w3ycP+M5yqH5kwCUEDJow6nHpJ6C
         +Gr0PJPMHIJ6jDEBUep4/E0l3k3Ja1a6fo9pPfesBXOErEwD/jAHjYRL2wJ/yDcZWeVW
         wDgMnpvtfDIez8WnI5hs2BnGQA2n4KdPOm+B/v/Bz3RZ056VT5ym7awDt/1+tn4Q8nQo
         saM6KU3gVwmRTH2NTur6ZeCi8kLBWl/kRD5xTPiclnSGhFyBXRg2X4tJwdyktRogAgA+
         4pnA==
X-Gm-Message-State: AOJu0Yz4koVcgyh2k5xHuaBk64Zuu2vZl0p9NFVfWFX7g6WcgNI3jRjI
	DBOJATK0wXPnSauGJY+0PHwmE8vAbfVsXafAaU0kaNxsBkR1pTXBm0Thfko5+8LLj78U6jyU/aW
	rSccgtYenHfs/yPpE/8cDzsqK6fks0785Y1HL
X-Google-Smtp-Source: AGHT+IFRIy72DxyOnaKptYGPfmSI7TYhaeEIrTEN9HpfourjbZj/0m6vpze7o2/iiPAowVfOKX+Zg9a5/Y2TvKMPASg=
X-Received: by 2002:a50:aa8d:0:b0:58b:b1a0:4a2d with SMTP id
 4fb4d7f45d1cf-5984e32241fmr231681a12.1.1720714284727; Thu, 11 Jul 2024
 09:11:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710220540.188239-1-pratikrajesh.sampat@amd.com> <20240710220540.188239-3-pratikrajesh.sampat@amd.com>
In-Reply-To: <20240710220540.188239-3-pratikrajesh.sampat@amd.com>
From: Peter Gonda <pgonda@google.com>
Date: Thu, 11 Jul 2024 10:11:11 -0600
Message-ID: <CAMkAt6pYAKzEVkKV1iriQei3opD9j3M4bM3-0yB4sX1wss+jsQ@mail.gmail.com>
Subject: Re: [RFC 2/5] selftests: KVM: Decouple SEV ioctls from asserts
To: "Pratik R. Sampat" <pratikrajesh.sampat@amd.com>
Cc: kvm@vger.kernel.org, shuah@kernel.org, thomas.lendacky@amd.com, 
	michael.roth@amd.com, seanjc@google.com, pbonzini@redhat.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +int sev_vm_launch_update(struct kvm_vm *vm, uint32_t policy)
> +{
> +       struct userspace_mem_region *region;
> +       int ctr, ret;
>
> +       hash_for_each(vm->regions.slot_hash, ctr, region, slot_node) {
> +               ret = encrypt_region(vm, region, 0);
> +               if (ret)
> +                       return ret;
> +       }
>         if (policy & SEV_POLICY_ES)
>                 vm_sev_ioctl(vm, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL);

Adding the sev-es policy bit for negative testing is a bit confusing,
but I guess it works. For negative testing should we be more explicit?
Ditto for other usages of `policy` simply to toggle sev-es features.

