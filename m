Return-Path: <kvm+bounces-41546-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F7BA6A21E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 10:10:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 66DD716A553
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 09:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67E052206A7;
	Thu, 20 Mar 2025 09:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MeL8izHd"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6F1207A03
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 09:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742461695; cv=none; b=RVY+Lvf5pkLz2+M2yWSv004JLLH6+4G39icUqjR2rU+Ay9BKieqK+nQBkxuEDjFL4Oq396ekAEhaGfbRqUDJDvXXzSTVqLW/HzAGUttzXG+FL7n3Vbk2gDIvS+xl9eX2tXOFkWpK4tc3dITlXcnjKqQW6jdobIQKQsDN23iKZ0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742461695; c=relaxed/simple;
	bh=5W1uHTX0JS3ybfrgNeMmG6TgEZd4dU4vl69eG6Vq4OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULBE0UJ+HCLawNMzyK7M1vx5KVB6lx0NSObRtq7k1UXu134vJqEbhs95ZHSUV5As0PA3p/BheCThHGw6FrkNnlE41wRKtT9cta5mzjgHhuFtiZcoHmeCp1dm15MC5mF592eq2sq7ZX96FxnP3RKOHZaRfgKCAbMuWSaLZnyVJOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MeL8izHd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742461692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bDTq60/uptS/vYIusNxJ/yOQlPzuUR9or0TJgSxpmhw=;
	b=MeL8izHdJigzrCfOpwdqrWSJTT1G8I0xllPlitL5DEDiNx4hJFqEZCwSjzmEnlRcM4YSSt
	F4k7ejJZ7wulKhhJzacqbi5qveoVEooEGUxRvbxgYp2zqOxGnWzo3LKt9FKhar0n1ltphm
	vVgcGS+JAt730/YLpbBzjpvqrX02z8U=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-qK6nK8SgPgumIUWeABpRLQ-1; Thu, 20 Mar 2025 05:08:11 -0400
X-MC-Unique: qK6nK8SgPgumIUWeABpRLQ-1
X-Mimecast-MFC-AGG-ID: qK6nK8SgPgumIUWeABpRLQ_1742461690
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5e6a64bd1ecso543280a12.2
        for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 02:08:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742461690; x=1743066490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bDTq60/uptS/vYIusNxJ/yOQlPzuUR9or0TJgSxpmhw=;
        b=qDCEZjnKmFBXCwhL2X0IN4adrf1VWK72UVsc1KNLLAFd7TuWF0TxLhF68Mrz53cBLx
         ammf1t7QVRcDISI0hKS98Hy2CXy71qjBFjZ/8GnKoSgiAtfT/BsfkQrSO6euBEVvCPB2
         5XezD7lBFOpJo6jbWxg5XF0vgC4HdaNOsEgz1e89W/8DWlyWPbpsMMTqMbND7AAJKLOb
         lmiA0fbIuGmMP5eQpI/LZJL/6IMjujXXsmkc9Ztd1EkxXTFbHxjRTBYQ4ew2iwFaInxG
         l0gFG/eksz/gYLLOUI2SlZH11sf+vikb/7IkWuH7qic84Ubx88H7ucMz0wRHO8m/AlA+
         rL2w==
X-Forwarded-Encrypted: i=1; AJvYcCXIfGQbulYogYZ/g1uKZp8/TNjCbn1+Uh3r3qGg1H4814NlaNS+zLY7ac9b4ULNX7s+1ug=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrqGdQXa7TkZo3lEL7C964U7wuO//bavim70idc+1dig+pWa3a
	eNKzrvIxOUnk0pL3XQN+ZWSKDNnDasPgy/21FJjL9+WwAnhV99txjq0gYhLJgOBmMSHkAo2VeaM
	IFwmalHbyLvCRzWmJB4vadV9bKZ9aNuaCvwWlDT2nsu3KqFlIVQ==
X-Gm-Gg: ASbGncvg2h5CblfpFFd62XpgGgJndP8M6m/cdfw3pcLz/CJxO4Y61iwRptvwcUek6aa
	NyHITdVxtpPOM9y1+btPPq7nF8kBSlQoykuYLGrgsEdKlPnIhOW7i7PCrhxqh7TEUQKzaZdSK48
	5CYurslBucDBoF1yA8MFB1oh97zZdLtMgDVegenBZ3nsWrjIXlicuMiRwp/aYx/hUFyDXq3/08b
	Dx/Tyu+ZclFeFrKLU7R8K+Pn1+QrVnDjK/h7e8TRR3LFLjoeDn6C6kxb7OGuxlbiwhUbaP2Qlw2
	N2pP5yUI9lXwvhPFZ+D3h4iTd55EJIY3U4MFjAM/izPljRVJdYrZgSPv60hqaCh3
X-Received: by 2002:a05:6402:13cf:b0:5e7:c779:85db with SMTP id 4fb4d7f45d1cf-5eb80cdea32mr5839725a12.4.1742461690251;
        Thu, 20 Mar 2025 02:08:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOQHfmcgMblKkiR1tHejD7TWeiNXKZXGZAyBKU76H5X4T1+QQ1dIB97fNyYdpVkDoNZIj46Q==
X-Received: by 2002:a05:6402:13cf:b0:5e7:c779:85db with SMTP id 4fb4d7f45d1cf-5eb80cdea32mr5839682a12.4.1742461689546;
        Thu, 20 Mar 2025 02:08:09 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816afeaabsm10004728a12.69.2025.03.20.02.08.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 02:08:09 -0700 (PDT)
Date: Thu, 20 Mar 2025 10:08:02 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Bobby Eshleman <bobbyeshleman@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>

On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
>On 3/12/25 9:59 PM, Bobby Eshleman wrote:
>> @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>>  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>>
>>  	vhost_dev_cleanup(&vsock->dev);
>> +	if (vsock->net)
>> +		put_net(vsock->net);
>
>put_net() is a deprecated API, you should use put_net_track() instead.
>
>>  	kfree(vsock->dev.vqs);
>>  	vhost_vsock_free(vsock);
>>  	return 0;
>
>Also series introducing new features should also include the related
>self-tests.

Yes, I was thinking about testing as well, but to test this I think we 
need to run QEMU with Linux in it, is this feasible in self-tests?

We should start looking at that, because for now I have my own ansible 
script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to 
test both host (vhost-vsock) and guest (virtio-vsock).

Thanks,
Stefano


