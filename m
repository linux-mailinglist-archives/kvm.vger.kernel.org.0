Return-Path: <kvm+bounces-65050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 28425C99918
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 00:17:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F7804E1F6F
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 23:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72F2429ACDB;
	Mon,  1 Dec 2025 23:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BS2SK2Zm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tPQfVHD0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC8823B61B
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 23:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764631021; cv=none; b=TpNtkAsexMbsfSLNLwlzsK1z5AvnCikgWoV6gJMmswcQxrspGjsdGqe5ib4FobixaybK2oKFJ62zCDMuRyxyofqdGc4HFYzTDI3Y6XuXMStqZMXXnOAmHxneXYzbz2WJ2qy6B6blIH5fcWlmVCgai8DUJ9xd97rHOUDsFLSt8rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764631021; c=relaxed/simple;
	bh=+lp93F6g8ek3RZ5nct/4V2jvnmStEmVEqjnyd/VFMow=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=gp6HrPsD6QprqD+ItB92X07xsQX+x1gMkWmOf8LT6/Nij/AG3mAhIMPWRAicZH+FjBDXJtHu8GpeBCuUbTi8z70IYBKyLZY9colBzOZcILVch+r1V4TVgqZat0W3dcR9bvxnnd9p9/2hjFrmtn5zsyGx40Ig0kgjR+1HeaB0tfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BS2SK2Zm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tPQfVHD0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764631017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w2JiQvYh5sm4dF/Ad/H8RwiLEUsI3vXlerU2PyyWqTY=;
	b=BS2SK2Zmb+G3uujdvGWMWHbnAZS0v8sxVIoChIYxDlKO/zdoSxOsaLwj26QvaYJCJalQst
	8+ZmDzqDyTtd2sGu69ejJrH4xBKLlY5REkF2FEkl2HV9DHgBE9Rcid/9nwjXaMi4XxnKTo
	UmzMXTV8/DE3LpcaoSHlgQqxBPFvtqU=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-IcIDPy7vMmestHiCdzs4TQ-1; Mon, 01 Dec 2025 18:16:56 -0500
X-MC-Unique: IcIDPy7vMmestHiCdzs4TQ-1
X-Mimecast-MFC-AGG-ID: IcIDPy7vMmestHiCdzs4TQ_1764631016
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-29557f43d56so52011695ad.3
        for <kvm@vger.kernel.org>; Mon, 01 Dec 2025 15:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764631016; x=1765235816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=w2JiQvYh5sm4dF/Ad/H8RwiLEUsI3vXlerU2PyyWqTY=;
        b=tPQfVHD0taPywCoYeDKp/vldZR47YYwduBYz5hLCl+b73390H9oISX0Efs7pnYu8g2
         siU6C/PSPvwRDeDN7Z6eU55iogiQNZR+zR+LKOGxOjki58T2V7sthhVXlgfYYQzq40Gh
         OpjlhFFD9L70R+zXmDZzxQpmDTicU0NF2p9oJPuhHVN4Vn4U/lJL6tGSVRNnQeoZczK2
         1P3KNKk8j7Sx79y7W7f34VhvoLvpXqFu/ZC43pEUzeNZq4fbmVVpyWCmlh1EPWx94Q5k
         2/mdZj1UIPaDcOQZEhj8jW0ZQ7W7YfWKVnebTexAWMWzX1AnNV63jVj1kuEMftn+rX+2
         ayow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764631016; x=1765235816;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w2JiQvYh5sm4dF/Ad/H8RwiLEUsI3vXlerU2PyyWqTY=;
        b=iEs1AGeTcihAcP2Bs5/vmehjL9BA1C+rFQquJbQjW1pWFbpQ4IeluX+7WCh3+vBRpT
         ys0KvSF0Wnpa78fEvC9gQ4UMSza2ByZp2PqRi/U1Kq1DFcFhxPPVrEio0sKqKf7Nf9Tb
         OBL2rKp8jSuYs3Gg4TFzC9eM/Zk7BGR+mu7TgM64aSIrU2cYimeby9kwrSkXMAsiifCt
         Ddsdjit1TBkpZqIAMWLEZ1+hkNMvR2R4aCXBYObeunE02qkGnbplDvm3BJzxV0TC4U26
         FMtJrUvQKKFPxT6ZbvzILOVFDZQLxIS74m3/JUITwkCLaay+4Rokvz+u/ep3F49sSJOp
         dxwQ==
X-Gm-Message-State: AOJu0Yw2UCFJ1YW+Cn+TA/4yJFWZ29560G0pc9ioOkbQROezetU90LtW
	oKNHW37if6CsQOjM+QIgSpo9ZgmlZX7V6bQWt3huauFR2g/Y0UuU5QX+oe0HsmB6cwT3QLmktbc
	d7tNuLwYKKtFeoS+hhyFpjNt4v0fcuIEAiW3So1SDmaS3gLq6OXoU2g==
X-Gm-Gg: ASbGncvhLA0VqmsonvncPkgThyKebU5Jl5ZYgibz+0e3iMz2NF4UCR7N2yw69Ejn1AN
	23Ve/HII+VMgGX1TF9bC1yVXQJ/1vmd1DEy/vg5nalQOHYVmjm0nmcKOA7xZuKIKgn5iUglqm4z
	kFWc2wTa/Y2tjxbT42IDwk8ebtsUogS33CtanRAJEuKN7HkTfshFCbGVGt5kMIeZxC0A9X1sqyU
	0OABTQHch3fOMM32dieH+bps5C4zexKRow5gijOsoSgL2+6IxddU1SXw4IibSH9/BBIw8NN+X/x
	kKkFH4pO9cBkqaIvbPLnfHlSKE9t1PSQdu3p/oDi1FJVvOvxSdhTo8XZ3pGLS1xcvVK1xZ8FKO+
	YRFrOn+IrGvddVpJHlAs/2GkV8NxDpoMUxQu/pOW4E4CpHRewEw==
X-Received: by 2002:a17:902:fc4f:b0:29b:ab3c:83a3 with SMTP id d9443c01a7336-29bab3c8498mr289489455ad.5.1764631015612;
        Mon, 01 Dec 2025 15:16:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFyevsaXlVkZQPgAl9fthr313SLT72+cWZt8TDFYWvlLYtQ2urgXFCv6ronYdUQmllLwTzXA==
X-Received: by 2002:a17:902:fc4f:b0:29b:ab3c:83a3 with SMTP id d9443c01a7336-29bab3c8498mr289489255ad.5.1764631015302;
        Mon, 01 Dec 2025 15:16:55 -0800 (PST)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb27504sm134068245ad.61.2025.12.01.15.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Dec 2025 15:16:54 -0800 (PST)
Message-ID: <1c1860a0-91b0-40fc-acd0-97f04e6b3851@redhat.com>
Date: Tue, 2 Dec 2025 09:16:49 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: selftests: Fix core dump in rseq_test
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.linux.dev, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org,
 seanjc@google.com, shan.gavin@gmail.com
References: <20251124050427.1924591-1-gshan@redhat.com>
Content-Language: en-US
In-Reply-To: <20251124050427.1924591-1-gshan@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Sean,

On 11/24/25 3:04 PM, Gavin Shan wrote:
> In commit 0297cdc12a87 ("KVM: selftests: Add option to rseq test to
> override /dev/cpu_dma_latency"), a 'break' is missed before the option
> 'l' in the argument parsing loop, which leads to an unexpected core
> dump in atoi_paranoid(). It tries to get the latency from non-existent
> argument.
> 
>    host$ ./rseq_test -u
>    Random seed: 0x6b8b4567
>    Segmentation fault (core dumped)
> 
> Add a 'break' before the option 'l' in the argument parsing loop to avoid
> the unexpected core dump.
> 
> Fixes: 0297cdc12a87 ("KVM: selftests: Add option to rseq test to override /dev/cpu_dma_latency")
> Cc: stable@vger.kernel.org # v6.15+
> Signed-off-by: Gavin Shan <gshan@redhat.com>
> ---
>   tools/testing/selftests/kvm/rseq_test.c | 1 +
>   1 file changed, 1 insertion(+)
> 

Could you help to take a look when getting a chance? :)

Thanks,
Gavin

> diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
> index 1375fca80bcdb..f80ad6b47d16b 100644
> --- a/tools/testing/selftests/kvm/rseq_test.c
> +++ b/tools/testing/selftests/kvm/rseq_test.c
> @@ -215,6 +215,7 @@ int main(int argc, char *argv[])
>   		switch (opt) {
>   		case 'u':
>   			skip_sanity_check = true;
> +			break;
>   		case 'l':
>   			latency = atoi_paranoid(optarg);
>   			break;


