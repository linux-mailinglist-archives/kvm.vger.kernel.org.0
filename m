Return-Path: <kvm+bounces-60797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0247EBFA142
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 07:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A4F2118C7445
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 05:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0C92ECD1D;
	Wed, 22 Oct 2025 05:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8Qtm84/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1453C2EC099
	for <kvm@vger.kernel.org>; Wed, 22 Oct 2025 05:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761111529; cv=none; b=Up6TPbyo8m8fLamA121fLdUltKtleYBYtaIV0PTxPjd5T8drEY73L6NnLiO5ToiB0fL3Cy5Y2Fa30/IQ5l+qG+fkeXbndkiYjbbo0+oNBXie6AXdYXHeVx2YSQxBxWlH3fR78ZJQI3wtVq+VPGjEiKsf+sKt1P67+MQZq2kXkYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761111529; c=relaxed/simple;
	bh=BD0r+9duyb0Je7KN6QwZlA2llUYLAAoXVTwTTHeoZb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h5aWRbN3zcJNaqsasmUYOq4Y/5y4V3YWgmMzK2o60KFeakcOcK7b+71ewhIIPeoxlicoqoO5/b+xPcyaLK+T2Upim3rjf6KUb441XkRDE9XPjq3F+QnJJzi6I4ofE5jmGNtkJRFAkM8rMs8hKyjzzI4knMUF81OomsDRFWH0XuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8Qtm84/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761111526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AO9bGgHA9SRDMxQBFatU3saNKYYbXbIllCsnpW+/KUs=;
	b=F8Qtm84/xJtpNgns68525nodqE6euSz+WOKNGjFLybqRXB5HfqIQKTJZ//9BpNXfcR84uN
	WzwA3VM4tmH83sU6+tEVH2VmWPZCbXeri+8R1n/5youoSs1GRt1X0EuwU/XZj688EtfN+A
	kscov5oxbPN6VhjdEaNqDFPbjlrig/g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-xgMws7WfNeq9eHl9AMROiQ-1; Wed, 22 Oct 2025 01:38:44 -0400
X-MC-Unique: xgMws7WfNeq9eHl9AMROiQ-1
X-Mimecast-MFC-AGG-ID: xgMws7WfNeq9eHl9AMROiQ_1761111523
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-427060bc12dso6904732f8f.0
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 22:38:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761111523; x=1761716323;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AO9bGgHA9SRDMxQBFatU3saNKYYbXbIllCsnpW+/KUs=;
        b=OViDJG3Msa0MfTjIKexQslKjvGNULkjaQ60MQVK7DuHbojCxEDh8mk8cK31mHGOFJN
         BsNZrYxDOkE3wrh5L6NP57UIc9EbSy+m0zKD34pZmg3wn+WckvnZ2xkxvy1UPOwj2vUT
         QaS3FR4zkQ2CUIVFzITqERRt4v3D47eN+MgkoqRQTU+47ckDWYiWGNKsrgi7j0Fxiscj
         tO+62pEHdPEjUEJO8E8ibFNL8z4Bc1Xoj2JNhuC4jjahkQTP8MR1IeNu7OGk7IXOGt6t
         Bvm6p1h3dh+ykOJj3eIF1etljtYx+r8pvrScdJdbyODP3zS+pkR0mDkgtG92OEIj+OOh
         y+oA==
X-Forwarded-Encrypted: i=1; AJvYcCW8gZ9D4qHGFT+0xiNIH0dzOw340etkNkoNLFR0rAlHDSBIoDrPEB/9NwIxFJxCjEfxPIc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQncipivKIM2lPZi+FYhoI7Ylhe6iOh9AnpOlP9QwVqSb5g7hD
	QD4hK355Yl8d+IzQ8spmZC418KJ5lO+yTDfE9N/KFZTejg8DQ9mdtL3NLLqa/w+/d7xGrvn0jgn
	UEKMyk37FAcTkMQaMPA+TzVlWXFmXq/qs21qDSBan75wh7dqd98jFvg==
X-Gm-Gg: ASbGncvhiP8p5o0uuja7pJf9hIheZLvsfAhIrGesFhEpkVXzWSTGvypWs2NL4J2tsm4
	HKB6VrxlbNvmqSuMbHPlMvv/w02SWmbQlALLFUbQTdWtiTgr9BASeA4UI+6l0BUPNIMFl6Df1yO
	zdnHfae4U644QJljhQgh1WzXtfHl3SvFlQe8oFbwdkmYi1EeLa61Mn0VriUeSaviETyVXnpIqQH
	yVDHG73/8ZXhBD1dQCXHaM3SEWT7LoXP2Yy+rC4A1A/TUCMbqYOvy8HAAtodLcQS4evUzi0tiTv
	D86g150cgVRMYksCKDgMCwfO8QY/0JMxO5o4I2NzBRjdPIrMOvs6WDG4N6N/rH9MpabL
X-Received: by 2002:a05:6000:400a:b0:427:492:79e6 with SMTP id ffacd0b85a97d-42704d83d9amr12240054f8f.2.1761111523096;
        Tue, 21 Oct 2025 22:38:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjl/ZOfjT4Svi3ER983luOVRdvr+S2/sxG9MG9uyIZrwESjrcFAROjL57Mw6QZVPlN9sOhBw==
X-Received: by 2002:a05:6000:400a:b0:427:492:79e6 with SMTP id ffacd0b85a97d-42704d83d9amr12240028f8f.2.1761111522433;
        Tue, 21 Oct 2025 22:38:42 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:152d:b200:2a90:8f13:7c1e:f479])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a9a9sm23976991f8f.29.2025.10.21.22.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 22:38:41 -0700 (PDT)
Date: Wed, 22 Oct 2025 01:38:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 1/2] virtio: clean up features qword/dword terms
Message-ID: <20251022013753-mutt-send-email-mst@kernel.org>
References: <cover.1761058274.git.mst@redhat.com>
 <492ef5aaa196d155d0535b5b6f4ad5b3fba70a1b.1761058528.git.mst@redhat.com>
 <8138fb02-f7c5-4c83-a4cb-d86412d8c048@lunn.ch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8138fb02-f7c5-4c83-a4cb-d86412d8c048@lunn.ch>

On Wed, Oct 22, 2025 at 04:20:52AM +0200, Andrew Lunn wrote:
> > @@ -1752,7 +1752,7 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
> >  
> >  		/* Copy the net features, up to the user-provided buffer size */
> >  		argp += sizeof(u64);
> > -		copied = min(count, VIRTIO_FEATURES_DWORDS);
> > +		copied = min(count, (u64)VIRTIO_FEATURES_ARRAY_SIZE);
> 
> Why is the cast needed? Why was 2 O.K, but (128 >> 6) needs a cast?

It's not - a leftover from one of the approaches I tried, thanks!

> > -#define VIRTIO_FEATURES_DWORDS	2
> > -#define VIRTIO_FEATURES_MAX	(VIRTIO_FEATURES_DWORDS * 64)
> > -#define VIRTIO_FEATURES_WORDS	(VIRTIO_FEATURES_DWORDS * 2)
> > +#define VIRTIO_FEATURES_BITS	(128)
> >  #define VIRTIO_BIT(b)		BIT_ULL((b) & 0x3f)
> > -#define VIRTIO_DWORD(b)		((b) >> 6)
> > +#define VIRTIO_U64(b)		((b) >> 6)
> > +
> > +#define VIRTIO_FEATURES_ARRAY_SIZE VIRTIO_U64(VIRTIO_FEATURES_BITS)
> 
> 	Andrew


