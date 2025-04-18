Return-Path: <kvm+bounces-43658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DED63A93776
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 14:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CF993BF137
	for <lists+kvm@lfdr.de>; Fri, 18 Apr 2025 12:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD9DD27602D;
	Fri, 18 Apr 2025 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eFHjbr2q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE8D275100
	for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 12:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744980611; cv=none; b=t91FVoJkGDulmNxH4B79TvOYQeH/2bETtWbK2expeAgTIcMfbFE92kRJb3bPUtXV5KAPllXhCrfqyHH2bzg/HmayXoQhqJtUse6BPCaeWzgZFSFBcx3EIKi07sW3Isu0jMcrJN9Ac07BTX20uPLlFCjnHYU7YkQzwVhiXgNkwAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744980611; c=relaxed/simple;
	bh=lU/Bb8SRsJwA1muJ0ugsKKBzbFwlb5S+M+WnlX3Dtu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q4MLrCNORCQIkmLmsLNYr+nL+5elp0W5szARlgtRVhiuHk8PTKymSyjHB4//t90/kZQo97qnttLYscJyEn8bLkCGwOf4vxEaapXBmakPfXZvMT2Fv16EzcIIe4HluedjqUdVeGudcLfQfL6eP2+ZuV4rV6v2+vDJ4gxP+tcGaBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eFHjbr2q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744980607;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Pj0NWeVm2rq3JDLuDor2eRBThe0KZ4y+ZCBSpoAl31g=;
	b=eFHjbr2qYLzhS3xBUcxGtG6isbkcAvhqYxG0Exn4i6zwnTfcVMdNZTKrxMN4y0dkMmUuV+
	AROc6dyC5dhoUBOPyHxhmxZRSI7TzSrDWfUH/AhaHc2p4+lm0yd638vegpKd129tWbC3s4
	A3IVRabebIV9pVvC1W6qOIlvIHqMLmk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-UdBKarzRPJWUHJki1ydMQw-1; Fri, 18 Apr 2025 08:50:06 -0400
X-MC-Unique: UdBKarzRPJWUHJki1ydMQw-1
X-Mimecast-MFC-AGG-ID: UdBKarzRPJWUHJki1ydMQw_1744980605
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-440667e7f92so7717955e9.3
        for <kvm@vger.kernel.org>; Fri, 18 Apr 2025 05:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744980604; x=1745585404;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pj0NWeVm2rq3JDLuDor2eRBThe0KZ4y+ZCBSpoAl31g=;
        b=jc32ZijOD16nva8r6TxGzUsybqjVwmXPGtdG0QVJFR98lZI20/6lprU+D78vepXMs4
         Tvy6EVt4UsU73N4W8pu08FP8mBfyJ6FHkuW9mDs9uSt5jfBEjJ1bwoc1b/2QEkxfQGx7
         XQKGDM00+Qv0N+CEmTnsPRf5TAXg9VoYyZ/KwNk/OnLsNhAAGt67Cx6u+yi30/252/XG
         nDi95MlE0bvg/6Cw8177zmJUOwAUV+zeIza1UHSXlYohghbr9dVYqkA+CnY3x5/RqO9T
         SlMLr/QZFQ+6LqCulWND3rzFcyTZRDAt6quj2Xb9V2kGkWs7lSYAs4YkKTxg7HJ248n5
         onxA==
X-Gm-Message-State: AOJu0YzIoO0V6UZDjVH9ckEQkWwKBi95iEsR6utlhba3x2aMslVfA9tG
	LtoiI9cCX9SQl8uiuprbleE6Jcl+4GZkAdY0aEHQs2ziw165AZ7E6FnvqJVcWCi7kxlSPNOk0LW
	TXqUhMie96KxTqKPCqlyzG6ACJj3cwDy4MvFlyRAU9IKC++QtxhOUPzeB7g==
X-Gm-Gg: ASbGncv3chH7XH+cs+4ciB+0MgX6qE7AtKY/n+CHiXOROqvYV1xcOruVGPUo/Th/YT3
	g/xhknyZlXczhYMovf3vtFKK6vUZupbaXiWsJyYwx5wMtQl6KQueWG+hG6h6D8eF0191FypPR7n
	8Zna/eQ097d9yRv+uhdf4z1+qVepLe9GCzTZefJpTB4SudPWpjE94r5itv6oS577O3LYqMGNS0b
	jjZPOWm/CsZB0p45IXTUO4fF7bUI3/+BB+D6u28MdzlSmKfx6yxLQSQvT0kD83XyYQ364cuOkn4
	jstAj1AFiCKMwWDF
X-Received: by 2002:a05:600c:a03:b0:43d:fa59:a685 with SMTP id 5b1f17b1804b1-4406ac1fd14mr18227035e9.33.1744980604578;
        Fri, 18 Apr 2025 05:50:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEKfYj/UlVHqAA3k9qrqcUBo+oZB8lHKS1w+1KJ1NFX6vzfV3M6177nP8w3IqQXOl+xKGOSw==
X-Received: by 2002:a05:600c:a03:b0:43d:fa59:a685 with SMTP id 5b1f17b1804b1-4406ac1fd14mr18226845e9.33.1744980604152;
        Fri, 18 Apr 2025 05:50:04 -0700 (PDT)
Received: from [192.168.10.81] ([176.206.109.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4406d5acc9esm21918455e9.13.2025.04.18.05.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 05:50:03 -0700 (PDT)
Message-ID: <596ce9b2-aa00-4bc5-ae20-451f3176d904@redhat.com>
Date: Fri, 18 Apr 2025 14:50:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kvm: potential NULL pointer dereference in
 kvm_vm_ioctl_create_vcpu()
To: Chen Yufeng <chenyufeng@iie.ac.cn>
Cc: kvm@vger.kernel.org
References: <20250418042421.1393-1-chenyufeng@iie.ac.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20250418042421.1393-1-chenyufeng@iie.ac.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 06:24, Chen Yufeng wrote:
> A patch similar to commit 5593473a1e6c ("KVM: avoid NULL pointer
>   dereference in kvm_dirty_ring_push").
> 
> If kvm_get_vcpu_by_id() or xa_insert() failed, kvm_vm_ioctl_create_vcpu()
> will call kvm_dirty_ring_free(), freeing ring->dirty_gfns and setting it
> to NULL. Then, it calls kvm_arch_vcpu_destroy(), which may call
> kvm_dirty_ring_push() in specific call stack under the same conditions as
> previous commit said. Finally, kvm_dirty_ring_push() will use
> ring->dirty_gfns, leading to a NULL pointer dereference.
> 
> Signed-off-by: Chen Yufeng <chenyufeng@iie.ac.cn>
> ---
>   virt/kvm/kvm_main.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e85b33a92624..3c97e598d866 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -4178,7 +4178,9 @@ static int kvm_vm_ioctl_create_vcpu(struct kvm *kvm, unsigned long id)
>   	xa_erase(&kvm->vcpu_array, vcpu->vcpu_idx);
>   unlock_vcpu_destroy:
>   	mutex_unlock(&kvm->lock);
> +	kvm_arch_vcpu_destroy(vcpu);
>   	kvm_dirty_ring_free(&vcpu->dirty_ring);
> +	goto vcpu_free_run_page;

Makes sense, but the goto is not needed.  Just move 
kvm_dirty_ring_free() above "vcpu_free_run_page:", in the same style as 
kvm_vcpu_destroy().

Paolo

>   arch_vcpu_destroy:
>   	kvm_arch_vcpu_destroy(vcpu);
>   vcpu_free_run_page:


