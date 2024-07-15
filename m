Return-Path: <kvm+bounces-21653-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A44931889
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 18:35:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2526C28380A
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 16:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A29FA1CD31;
	Mon, 15 Jul 2024 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABKj8apY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD181B7E9
	for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 16:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721061343; cv=none; b=ZxCgpkCZK4abuTnPi/eWDT3zyR1AtQCHPBLKHSFfALsk1VZTExrwFFwrYoldlm3s5ssK5JdMt35J1SQZwnAsPjKPARSIa/4TfURwNDZSw7R/pJYUkhNEB/clq79lItW834SA+QQHO4CYgpvolzIIl572qFBg3JVmDErpL1Mqdvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721061343; c=relaxed/simple;
	bh=odHtKhyc9x4N+VpJWpMYT8G+At8j5bJ+9xLfXcp3Ibw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qPuUTPNvZpQo4G2yZuKCP3zd6Us+AUbgdjO9GY4hy7wPG0rxeoLx64KWgMopKcURPnSlbDJzR+ErHRJ+JXd5UBSbm+xDoO+TP5RieC5mJYDiy2Pk9EP6o0WnaOTxZrFl5xPbdxHDfrlYcAhgLh09NuvSy0wuZBcOVV7e8La6bBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABKj8apY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721061341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iS9Rw1EkQ2Yc2L2pZuUTIBeOwAXBu/F5Bf6ABfLlinU=;
	b=ABKj8apYav5iK5fhj6b0On/XH6rThwKHKGgkEtNPCGOYe4ver8eaweCOog6yaBoLqCR8N1
	jX5b8+NSliuTgIzV22Sfryiq5TSNzL1f/E0/QsGjh9YiMvlXqVRDShrvFyGsfgdLQwNTZC
	MaPjNUZsObU7I0VHufOMEsnQOGTqVjA=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-EwnJQwflN2urQ6bp5wyQYw-1; Mon, 15 Jul 2024 12:35:39 -0400
X-MC-Unique: EwnJQwflN2urQ6bp5wyQYw-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3835c6e5763so53088725ab.3
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2024 09:35:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721061339; x=1721666139;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iS9Rw1EkQ2Yc2L2pZuUTIBeOwAXBu/F5Bf6ABfLlinU=;
        b=JgLYL/wxLNWkNdxy93zRDkenGapCiVoDZZp6/GfpgqcYDTui8Z9HMkzXyuoifLx+Su
         lKjSBTqQL1+8iohI0lM+/gEky3Z/q4zZE20uzudYfqp7DcL97s6yEF/Qd3K4VtqtbXBq
         57Qo40QNuNBTa9/GmwadnWao8/K19ZhStx3a9rA/+WxOvvsZKO4jlVjYQPoMISKmH11p
         Jz1fhmsF8XjLMh02khnqeDNw1NvTUSmaIB+vc+UWCvTES6n7P4AOQuSMYwZmioQkP33T
         GOzf14DkxSMWc+PmlegVbm0Kqw1IQ10oi0g+TeUZnI0g1vS1WYCRpAA2BaTLm77ssPEO
         nW8w==
X-Forwarded-Encrypted: i=1; AJvYcCX0nGVDe2484WnNFgcbbRKMtTVjHdWUla7Gv2EFkdH69x26Bd1PuakECn0JJkCUZ3FZBJ+X2yqNUXq/QPXOW4a5ez+A
X-Gm-Message-State: AOJu0YzLoA7h0kyysDqYdEyx8oWWQ8DDAA1J3G2fZK7Zx7sKXp2KhTcq
	i7e7aplfi4RFT0DNBn4MTXIkLtit+GeFWELxgQiXb28PSjEPySTrkFAfSFecgnR+jLWT9TcvWFH
	W6aawgH2wjwqvCvBUO7tJqeREIXn/cIuABwIi29DXGB+6cuhYcw==
X-Received: by 2002:a05:6e02:20e1:b0:374:9b99:752a with SMTP id e9e14a558f8ab-3939f4af59fmr4333745ab.14.1721061339010;
        Mon, 15 Jul 2024 09:35:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5GGCFUYrZmA3U7gSzsm3iXM+W7dKssQ9LTw5nTg2Z6p8f6D0pQ16AxdkbJqYZil9SOQDSiA==
X-Received: by 2002:a05:6e02:20e1:b0:374:9b99:752a with SMTP id e9e14a558f8ab-3939f4af59fmr4333545ab.14.1721061338793;
        Mon, 15 Jul 2024 09:35:38 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39010ce5f54sm17490725ab.56.2024.07.15.09.35.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jul 2024 09:35:38 -0700 (PDT)
Date: Mon, 15 Jul 2024 10:35:36 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: Kirti Wankhede <kwankhede@nvidia.com>, "kvm@vger.kernel.org"
 <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org"
 <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] vfio-mdev: add MODULE_DESCRIPTION() macros
Message-ID: <20240715103536.3e1370ef.alex.williamson@redhat.com>
In-Reply-To: <3717c990-ac93-4a43-a33c-bce02a066dfd@quicinc.com>
References: <20240523-md-vfio-mdev-v1-1-4676cd532b10@quicinc.com>
	<a94604eb-7ea6-4813-aa78-6c73f7d4253a@quicinc.com>
	<MN2PR12MB420688C51B3F2CC8BF8CA3A8DCA62@MN2PR12MB4206.namprd12.prod.outlook.com>
	<20240712163621.6f34ae98.alex.williamson@redhat.com>
	<3717c990-ac93-4a43-a33c-bce02a066dfd@quicinc.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 09:17:41 -0700
Jeff Johnson <quic_jjohnson@quicinc.com> wrote:

> On 7/12/2024 3:36 PM, Alex Williamson wrote:>>>>   MODULE_LICENSE("GPL v2");
> >>>>   MODULE_INFO(supported, "Test driver that simulate serial port over PCI");
> >>>> +MODULE_DESCRIPTION("Test driver that simulate serial port over PCI");  
> > 
> > Seems the preceding MODULE_INFO needs to be removed here.  At best the
> > added MODULE_DESCRIPTION is redundant, but "supported" is not a
> > standard tag, so it's not clear what the purpose of that tag was meant
> > to be anyway.  Thanks,
> > 
> > Alex  
> 
> My preference would be to just add the missing MODULE_DESCRIPTION() with this
> patch since that fixes the existing warning. Removing an existing macro
> invocation is out of scope for what I'm trying to accomplish.

This adds a MODULE_DESCRIPTION that's redundant to the current
MODULE_INFO, therefore I'd argue that it's not out of scope to replace
the MODULE_INFO with a MODULE_DESCRIPTION to achieve your goal.  Thanks,

Alex


