Return-Path: <kvm+bounces-41688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99460A6C05A
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 17:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4EDB016B356
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 16:43:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7538A22D4D4;
	Fri, 21 Mar 2025 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUiTPsUZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386EC13B59B;
	Fri, 21 Mar 2025 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742575411; cv=none; b=WCfHRVCzS37zQ0shW/6HtmocQg32bxIZhsx+WqrVH2LX3uoVQRuBlPbUftTagvkJMkG2TIy5e8qW2nhIyiTnaygY4WN3lGJY+NWGhLjy13nrQBakLDHHY3JsWllccVbxn3xrgr0TEqgHplx3vkDMyozpXlDa6W2cyxTLpwWUVjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742575411; c=relaxed/simple;
	bh=q8gY0EHYv1f0SNCN1IiS93/JbkcsovraFqehXvDUYac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p0w379Fa5utKDQb+/69y+Ut8tVJD8lmvvqKnY/rs6ZGo+eV6+0YOyGZLUwZWsG1auCwB7vjxCAY0e8DeNp4ZfuNnVFkcXcXQrIx7y1ky+B62BC11NcA1wCAo5HVw0XmrboFUlCjQ1iHH/oFZ9thARvuoB4YGO7yDroE30C8OxBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eUiTPsUZ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-224191d92e4so45204215ad.3;
        Fri, 21 Mar 2025 09:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742575409; x=1743180209; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/aJTPH+1xMkR4Zaf05Ht/L3jxae3E9cyEnH7B1bM0G0=;
        b=eUiTPsUZkHShvkqy8DZjZw7ydtXi4IwkuItp2YZoqtfGTPdaoDyxQSJCJFdrNMzsGD
         05ReMpVzdYwIoiVpxIXq0vX1u2gHVOWtevaycGa1wQ5aS3n+AYlwHeRXoHR+8YQIaGUa
         8L6aH/QzASDWQtJjAAyHzMMsNj1B4SOSefaXRFf736CFya3+pKnsQgNPKkQilEkt1BDB
         UJrpH8+U1GmRbTh4644rmu2PWbWZE80a0kfWjEw4DgT2rYumBF6sjm5SZwmjdpHF0Hq0
         GTHYrQEpTmYN5xkT7ZcYGp3Ub/7w60Syws4MsqNZPc7QUifN6XRITXBAt/IVH31/v/vg
         0ddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742575409; x=1743180209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/aJTPH+1xMkR4Zaf05Ht/L3jxae3E9cyEnH7B1bM0G0=;
        b=DNSrtFmABSyin2NAkI1yJuQRF0Zc9BzqjTv83emUFoWivAfjO4Q0asjquIAIdVMWzX
         cTNwBqIvDxpi83zWvryaCyzsJWk0oqcYTrmlkfi4lR6FsG4hWq1rlOO5DXq/g1S52aCs
         xNArZKas7N/tQqhxqMmLJFBdf5q09HWCic//YXLieFEYQDJa/wt0NkgS0wPMfrNPZQoa
         hUp51wrau2t5vsxcu50noY0+H5iOHGXjYiIbmyxYwpFMrgQbqrfBTy5QhtkAtdGcshEw
         CoYwcRSzPvxhDlqU4KXYlqgPq4bINHV4rjDmEsEIIxOigWoIiiqkTWfO5+jzaSFWvLle
         CmNw==
X-Forwarded-Encrypted: i=1; AJvYcCVjFvXseNAMvMOKF23X+KAz9Q7l3Dm3fmNvwPmMXkw8WDL1wW7n0ImsFv0mHrWHgeX8oFE5w4Fq@vger.kernel.org, AJvYcCWavUzQf0ScOa4Lim14Z5jc7hMowBVg+3B4zoikj/3qYap01W+wPBFD86L1VGoTJ4jSA9E/t1tAwKx5g2UK@vger.kernel.org, AJvYcCWiKfmd0cj7w75y8uLxn5OckP352yRLGVEE4ml/NKJe9F1Rff1+Ef7mwfxR2PKI1DpdWi+P0x29SYVnHSsO@vger.kernel.org, AJvYcCWwI1B+L5FqqajL8l7J2fX50QDyWhmBCCGaUd/rfpmC0zQYUmuJ4JnBEi0ZfoWF7CpfNiY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBOvTQcjZqlT+fY+S3GJ5QyhMDYKls+Y94iwAhOrNAt6RM83sT
	Bi8EbW9fS0/oRwC7gXDNjn2W+O5vKmRsmB/oS6FGRbOj+tlAvqb4
X-Gm-Gg: ASbGnctITVPqzc1muvI01+Qkd8acKfoW7N8uAKY//0Q940fFRyc+VGxt5gZLhhAUmr1
	PFKNnJAUDibDhZ+vuoOqytA8N2fdYxkyu8YRgSD4Ol6x31SbQJPeWroywOSCuyVk5EKLTlbO9GO
	XNh+NRf3trIh0h+tQEch0o57Tu5+cmnDlCpTAEz3Wjt2Ow1pMINEnD5S9VPwn6hZ8v7UoEG05Z+
	BEuMnjE3FzwQCURl3iiCoY9nurDEy/EpSobsqllcnKqPrHQl1CjnL+EfDL0vQiutY80wu3AzikI
	7PjhRGaEf1lMS6qCQvlourzC8P30ZCyvcyTMasaWxoOIAPj622KU5m/9ClH9YOqWkA==
X-Google-Smtp-Source: AGHT+IENp6UIAwlpkbF6We8IKTNIq+1iFjd3EWQYgWjKi8R9GSQ9a0yFuxD7FT/yHfceTqi0iUTpuw==
X-Received: by 2002:a17:902:ef12:b0:223:88af:2c30 with SMTP id d9443c01a7336-22780d8cfeemr57519585ad.16.1742575409441;
        Fri, 21 Mar 2025 09:43:29 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811b2b30sm19212985ad.120.2025.03.21.09.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 09:43:28 -0700 (PDT)
Date: Fri, 21 Mar 2025 09:43:26 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH v2 3/3] vhost/vsock: use netns of process that opens the
 vhost-vsock-netns device
Message-ID: <Z92XLufHveVjpI43@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
 <nwksousz7f4pkzwefvrpbgmmq6bt5kimv4icdkvm7n2nlom6yu@e62c5gdzmamg>
 <Z9yDIl8taTAmG873@devvm6277.cco0.facebook.com>
 <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqkgzoo2yswmb52x72fwmch2k7qh2vzq42rju7l5puxc775jjj@duqqm4h3rmlh>

On Fri, Mar 21, 2025 at 11:02:34AM +0100, Stefano Garzarella wrote:
> On Thu, Mar 20, 2025 at 02:05:38PM -0700, Bobby Eshleman wrote:
> > On Thu, Mar 20, 2025 at 10:08:02AM +0100, Stefano Garzarella wrote:
> > > On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
> > > > On 3/12/25 9:59 PM, Bobby Eshleman wrote:
> > > > > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> > > > >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
> > > > >
> > > > >  	vhost_dev_cleanup(&vsock->dev);
> > > > > +	if (vsock->net)
> > > > > +		put_net(vsock->net);
> > > >
> > > > put_net() is a deprecated API, you should use put_net_track() instead.
> > > >
> > > > >  	kfree(vsock->dev.vqs);
> > > > >  	vhost_vsock_free(vsock);
> > > > >  	return 0;
> > > >
> > > > Also series introducing new features should also include the related
> > > > self-tests.
> > > 
> > > Yes, I was thinking about testing as well, but to test this I think we need
> > > to run QEMU with Linux in it, is this feasible in self-tests?
> > > 
> > > We should start looking at that, because for now I have my own ansible
> > > script that runs tests (tools/testing/vsock/vsock_test) in nested VMs to
> > > test both host (vhost-vsock) and guest (virtio-vsock).
> > > 
> > 
> > Maybe as a baseline we could follow the model of
> > tools/testing/selftests/bpf/vmtest.sh and start by reusing your
> > vsock_test parameters from your Ansible script?
> 
> Yeah, my playbooks are here:
> https://github.com/stefano-garzarella/ansible-vsock
> 
> Note: they are heavily customized on my env, I wrote some notes on how to
> change various wired path.
> 
> > 
> > I don't mind writing the patches.
> 
> That would be great and very much appreciated.
> Maybe you can do it in a separate series and then here add just the
> configuration we need.
> 
> Thanks,
> Stefano
> 

Sounds like a plan. Thanks!

Best,
Bobby

