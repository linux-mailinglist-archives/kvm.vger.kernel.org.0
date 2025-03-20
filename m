Return-Path: <kvm+bounces-41600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0368CA6AF7C
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 21:58:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 419ED1895370
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 20:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8237D22A4FD;
	Thu, 20 Mar 2025 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHhqqZoM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C8E190072;
	Thu, 20 Mar 2025 20:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742504267; cv=none; b=OiL6fvF2MVVO8upc0A8jn+Jp5QNiMeS/Zc7gfqu6Rm8Ktl8veI7sDoulFE2TGOpKuR1DfJYgySXiCTpG3Q71+jaRekx7hEDKeGGtLKcSP24hPiKr6Y49VGQQ8JPXN1IptpJlh2S8WHxjglyHdzf/YCDXSATKOGX3wEJYodNFlTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742504267; c=relaxed/simple;
	bh=0JRxuNmPWg0BXu1gLvztZG/5XmSPd/ecKkcEAz6ETsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itkKI0CUjlIXItfkvyIDrNPR2et0yUUbTC3LKICaP1Ztbr9h9Mg85V31ZFmQDSpjMOLBqb3uaYMXgkKLX5+OSeAjm1h9ajNtp0gqb1uGgDLsun9lYoXHW6QEbuF68EvFp30z2MMWiolsn1lyjLR2LYcMKRSYVvlotvwY0jBvT70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHhqqZoM; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-224019ad9edso31045705ad.1;
        Thu, 20 Mar 2025 13:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742504265; x=1743109065; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yzKy/lOEAHXd03F/+5PHR8yNFdtPSdO5sEmGvZ66KuA=;
        b=nHhqqZoMtJbxeSHTsJ9mMSYUuzuepOBN8FeaxSFd7g45A7miGnZObGYY4DSAkmoWZ0
         mwBZenptPB9cXHi3UxPi03lzdmzjzpWSTB18BsdETdWpTetNOi4cUBPp38h0b5ise5Ht
         PhQoMD4Mlt6xVCW650LgCSo2jKGVK2nrgJKaBa3XkxXI5FmRQs8H+5RKATn5HBMZM8SM
         nVf34pdSFKt8dR0PB9tmzrjojT1MhKiVi1iFoYGsxw+2yayaNbwnfXnt0lbUftqK8r6/
         PXy91fb1ufkpqwD93uT3jSIVMVEBN4vFOUBmNKp6L+pdIRyPB1j1IpUdU8uEjj8IjMH+
         e03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742504265; x=1743109065;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yzKy/lOEAHXd03F/+5PHR8yNFdtPSdO5sEmGvZ66KuA=;
        b=FuaSopNPVEwKmdt5/EmFL3i8RfEdXWDW05OmO3GFg18rkt1IRVqXWw/br9Wfq5iE9a
         rhPnp9pHIgHdEOVFVjjCgDDV/exAKLF/WU5RYgDV2PY0OAxMBtnc/TPXLNkgBhu94ToS
         zHlekJ67Vv4ePmMc58NofC/cqDSMn6imLmf26zw0EKlH0q9Be/2LfiMXFjKIpqDK1wj+
         eThRBVg2H1wljAFlSWFnaldBGrU3DVPF70NY3D1b2XWPTjvebmJU80h1Kv+M+4OBZ/Xc
         YXgr0d0mrp2hofxOjTOPa7WQZ8MruT4C6CxQy4HXyNiNLTioANrOXwL9xfiP72VqEfJN
         w8yA==
X-Forwarded-Encrypted: i=1; AJvYcCUtvOAWYS2hRFGWkbf4lLO7Up4zoqm0E0iCWnd1ZymJMYFfduqqADxeYLL0/VCb7Xsf5YCVEv/Nj5a8Lzi/@vger.kernel.org, AJvYcCVoqbHZMXSKFipq4tYQEuwPxrnihw3lYubxghkVF7mAQoCCCeZykM4m0u0Llp80+g2rS1E=@vger.kernel.org, AJvYcCX5iPuoha9xL2AC+e07+yecxz3AAskLTTD/wGwyVY611KYxg4x9ZvjQ/9xjBaAeALe2A71teAnD@vger.kernel.org, AJvYcCXPkFUXBdOj6DDDJDhkkr2hKTfB6ru2Me+xufhw60i9GNkkp7zJB0jMpLC/UfCARSzntqt5Xa5FeLC3/4ON@vger.kernel.org
X-Gm-Message-State: AOJu0YxhmN5wafQMefYOv3WavdpxVNCA4UCal8l3HBB52YjFc01xZS71
	2eUhLDlhagOn7BYcqgbOgXOhJVUs9PIPQ1MRCfvgzfrLEGyCJ9pU
X-Gm-Gg: ASbGncv2ymCPxaGU08Hhk/IQ2bnE1ZKxRhvrXu0zKQUdvU7THYl9phmCjL5OwNnWnPG
	5+QhBJut2WlYOIDbdfS+Zfy85Drpu1ZYkRcn7l1FdBaHSHbsEza+InEweu7sq/Y70WrcQBAgFWe
	9F2uahkhkcferErHT1KxFC3bEn1Qg1FI7i7yTGvGbhW8LyrNUzD8TL824CN/CYVOi0L2mfcF3Az
	6yhiPv/L8iHeJBmSiOehwwiaW9e81b6cvNdmorrBsUyoMSSe44SZLrzIdFohzscF7f5Vm6mj0Fu
	ZeHSm5mdm48NJ3HKiDmemljhQ+4fCGKXHU8OfJVmSKv2TsO+T23RlqStJzbvvopDHw==
X-Google-Smtp-Source: AGHT+IEdn0605i1cah5WXs7GYx77tApjB5zexLnr8cToDi7Wb0H33V6afUzxrEpTrcHaOiAbfUfReg==
X-Received: by 2002:a17:902:e54d:b0:224:76f:9e44 with SMTP id d9443c01a7336-22780c508c6mr9676135ad.8.1742504265569;
        Thu, 20 Mar 2025 13:57:45 -0700 (PDT)
Received: from devvm6277.cco0.facebook.com ([2a03:2880:2ff:4::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f45e89sm2568245ad.93.2025.03.20.13.57.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Mar 2025 13:57:44 -0700 (PDT)
Date: Thu, 20 Mar 2025 13:57:42 -0700
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
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
Message-ID: <Z9yBRisP+FtTID34@devvm6277.cco0.facebook.com>
References: <20250312-vsock-netns-v2-0-84bffa1aa97a@gmail.com>
 <20250312-vsock-netns-v2-3-84bffa1aa97a@gmail.com>
 <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <09c84a94-85f3-4e28-8e7d-bdc227bf99ab@redhat.com>

On Wed, Mar 19, 2025 at 10:09:44PM +0100, Paolo Abeni wrote:
> On 3/12/25 9:59 PM, Bobby Eshleman wrote:
> > @@ -753,6 +783,8 @@ static int vhost_vsock_dev_release(struct inode *inode, struct file *file)
> >  	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
> >  
> >  	vhost_dev_cleanup(&vsock->dev);
> > +	if (vsock->net)
> > +		put_net(vsock->net);
> 
> put_net() is a deprecated API, you should use put_net_track() instead.
> 

Got it, thanks!

Best,
Bobby

