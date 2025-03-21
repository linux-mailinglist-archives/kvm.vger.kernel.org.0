Return-Path: <kvm+bounces-41649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FCEA6B86A
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 11:03:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 047CF3B5116
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 10:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC521F4725;
	Fri, 21 Mar 2025 10:02:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fh2ozByb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D81EEA5C
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 10:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742551366; cv=none; b=lyvFB+Eo3dE2bdSMYObR8nsT3Dw196HaC3CD1d95PAKEjVT3wtUKB39QVW+2OU++HgBDdfCoiCfjmTwiN7gp/W2MjPW5jpEJW8GzWU67nIwNCBek0ZbKekDunBC73UYvcsTcta7aR2ZQ9UDy4F1T+l7K8cAAFpe7gc3GcHN4XEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742551366; c=relaxed/simple;
	bh=7FXB9MgUSNIAeCSTjixx/fGT1P/pEpqm6PYZY4ugldk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amkCmz8SVIRgt2YWF4WegfCRrLnMJg/X5Bb0hVXDTuEhpOj/dUYCl7GVnz2HYZJ0NaLoToZNt4Z1GrVlSrecXJlcIvDhuUeUPoL9h8v8Jg6gox9G8kBkuqJ55Btp0i0OfhQ2rq5OjRIcyBcvCAygzG7xdd6HEZ1fermuRQsWn4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fh2ozByb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742551363;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z1fasRIza0+wiA592mMux1XtH5KpwcITkoYkMYOlXyU=;
	b=fh2ozByb7XrKwBDe232od9RzU4T8w7G0yMGs6geOIeClm1OdZd5M1RFiAOPsb7z8nrZKQW
	cya4Q6z4/LgJNScLmHjSjUDuke66TkB+7Z86XkiCYpldJ1iOWgBiAJ0PLhxLOuo2RBtNqR
	zj79BGx3LkZGjSuwa0hAzPlhgRRvAFM=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-VBo57_ejMC-MdEVxvfn7VQ-1; Fri, 21 Mar 2025 06:02:42 -0400
X-MC-Unique: VBo57_ejMC-MdEVxvfn7VQ-1
X-Mimecast-MFC-AGG-ID: VBo57_ejMC-MdEVxvfn7VQ_1742551361
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-ac21697a8ebso165223366b.1
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 03:02:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742551361; x=1743156161;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z1fasRIza0+wiA592mMux1XtH5KpwcITkoYkMYOlXyU=;
        b=fdq5Abdzu7IxI05DNSi9HzAEBSKwLmTjryAAuPKvJUOWXw54IXgKziE9h6CoCs36Hk
         338M/vPmxX+YEtkKrxpoyU8ARakXilnzaawSjOOPQUHU1TbwKsWQmOCEs/7xQjJUpeiT
         gGEIqJRtZ+VraQExA2Aek9F6mj/7cJDiDorzB2ai+++dWOJ0mtnHB920Txxt0zQbx2m4
         t7L4cPHPewTLrChqZVCqcZZ9hz0Hb2z3MvADcf+LLbDVST+0nXbcBdjvNsSaaDgS3Pzb
         1Q0O6v7bk0mnTU5lXuOjMdXxZJ0EYOmf7JL28rLAon6ZbCLPGCJKQ7tMQ2HwxLTDOiM2
         9HvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXb3Qnrx/FI+93yfXoSCzgBGeAlXZ3K4fEnM+C0qAm3EzdlIpJ2g4M7dBO4FuslEnE71qo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh7N9v5Tq4bX30xkM0t0UyQE2haqxVfvAaMfakeWiHZeu9mZ0B
	XvBd/x2Ifwui3XFZzSJQOMr1y86FpSaQmd1ON2R992pJxc6MCiVKFZWVrv14vB6fS5P8twYot4I
	GOZaTetFF70nnVc49drM+I3a8uKkrYroWf89Pn2LwK/jgnt8xuw==
X-Gm-Gg: ASbGncsY1BNHCdZSR+kHo/ijJLUJn39qF6wrg/JQjiJnUm+VxzS8iBW8WRmGTqIAc5F
	I0YCIi6bZgXALeVyInKvDFrqP9nSTsaZt1Aq5KBPGEuLeIYYRmPkX7rOqsDn/iOtOYIB4aw/uBe
	xLrcKUfWlEzg/XetBK41Y3hYJ3dVCxmTxgXqjgaBVCKDNT6WdIDH+Qz7eNJXs9xY2eEguLk2gnE
	yt7ZGjoN9xZhEwB8aCZmIOT/QqXW1f49+jws5Ddf53C43Fsd8VObjAzhSxLNkXW5ks1EG8gC2m0
	uyfN3gzLrAWc9Wa0PP9tPLvEw1eoWMkMr+kqdBz+HgZ57RUToIW9ZmSrZH7qiGu8
X-Received: by 2002:a17:907:d7c8:b0:ac3:9587:f2a1 with SMTP id a640c23a62f3a-ac3f20f2eadmr273955266b.20.1742551360976;
        Fri, 21 Mar 2025 03:02:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHI1seRG9imWZDzSDGMTwRVM4KqTGFuBDv5cjB/u4qDI0LlvpoSZCACNxNmno6+XKEHNnW4Jg==
X-Received: by 2002:a17:907:d7c8:b0:ac3:9587:f2a1 with SMTP id a640c23a62f3a-ac3f20f2eadmr273949266b.20.1742551360312;
        Fri, 21 Mar 2025 03:02:40 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3ef8e50b9sm125525366b.55.2025.03.21.03.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 03:02:39 -0700 (PDT)
Date: Fri, 21 Mar 2025 11:02:34 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	"K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, "David S. Miller" <davem@davemloft.net>, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
 <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
 <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>

On Thu, Mar 20, 2025 at 02:05:38PM -0700, Bobby Eshleman wrote:
>On Thu, Mar 20, 2025 at 10:08:02AM +0100, Stefano Garzarella wrote:
>> On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
>> > On 3/12/25 9:59 PM, Bobby Eshleman wrote:
>> > > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
>> > >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
>> > >
>> > >  	vhost_dev_cleanup(&vsock->dev);
>> > > +	if (vsock->net)
>> > > +		put_net(vsock->net);
>> >
>> > put_net() is a deprecated API, you should use put_net_track() instead.
>> >
>> > >  	kfree(vsock->dev.vqs);
>> > >  	vhost_vsock_free(vsock);
>> > >  	return 0;
>> >
>> > Also series introducing new features should also include the related
>> > self-tests.
>>
>> Yes, I was thinking about testing as well, but to test this I think we need
>> to run QEMU with Linux in it, is this feasible in self-tests?
>>
>> We should start looking at that, because for now I have my own ansible
>> script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to
>> test both host (vhost-vsock) and guest (virtio-vsock).
>>
>
>Maybe as a baseline we could follow the model of
>tools/testing/selftests/bpf/vmtest.sh and start by reusing your
>vsock_test parameters from your Ansible script?

Yeah, my playbooks are here: 
https://github.com/stefano-garzarella/ansible-vsock

Note: they are heavily customized on my env, I wrote some notes on how 
to change various wired path.

>
>I don't mind writing the patches.

That would be great and very much appreciated.
Maybe you can do it in a separate series and then here add just the 
configuration we need.

Thanks,
Stefano


