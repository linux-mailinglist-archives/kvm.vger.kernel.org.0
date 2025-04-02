Return-Path: <kvm+bounces-42483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B46A7924C
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 17:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C82416D2F9
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 15:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1321552E0;
	Wed,  2 Apr 2025 15:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hqghdk3L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D2D2AEFB
	for <kvm@vger.kernel.org>; Wed,  2 Apr 2025 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743608413; cv=none; b=Yy7xOIIMOdxcO778quClMtt69CdQNRtsgT9fSZksLWyRAHLnAplfh2WmHJwfzqa1dSJ/4oCzCQUz3uJfCCDArfUazNTa4WqwrS0dfeCi72f7G67KY0f1gZwhwaZqpgwlpcZS52lcAB8LiUvmdLh60fdY4RaaXgpYgyG7Yg1KrCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743608413; c=relaxed/simple;
	bh=Pbq1dx/OnJbPO7NellCFhQ39y6lY/rmd0Eej3PvX2s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lQe63rTNHqy+XfosXIll9rNmLJ6rX+krm7MRp3Ws6BWY2Z2tmejsthe06rjudyghqVrsUew5JlN89ifFCoDF1VrrZQ01OcTEW6ZGj3PEhJBeyMc7HwbPTsZUnKndF+e7qoDh/E8qM0Es6/9dZ523akNGRa7O5YCEOjzk3IlEpYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hqghdk3L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743608410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6nUx7Vl7EvSuoWp742ECf14m48HpSY6aOAHXmisq0nE=;
	b=Hqghdk3L0WmHFcqIgTcvZIObcQtFIOPDXqyJzhtw4sP+OYgYlcBt65Qcg6f41sPuHUpPzk
	wxTVE+Pebw4w0Ztk97/1ro+7uTpRgJ2x8UoSeHcrvx/qHJBG9FDyr51gjeiXdK6KcJdyLd
	k3kVnXF7ZQ+ujhVgpytXyGvGXkyCRTw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-g969PTsBOxmjwJel8vdJRw-1; Wed, 02 Apr 2025 11:40:08 -0400
X-MC-Unique: g969PTsBOxmjwJel8vdJRw-1
X-Mimecast-MFC-AGG-ID: g969PTsBOxmjwJel8vdJRw_1743608407
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43d01024089so58807155e9.1
        for <kvm@vger.kernel.org>; Wed, 02 Apr 2025 08:40:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743608407; x=1744213207;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6nUx7Vl7EvSuoWp742ECf14m48HpSY6aOAHXmisq0nE=;
        b=iVXvK4CHWJ+wzUTGKKrDXg6FJNsqrHdhcXkmJ7tu1QPe9voB3jLLgMUOH04GKbcxFV
         4l4Bc6Zta+lzhd1iijBkxmkDBOM0m7IAEQvA1KRz/NZFciHcK/IPN/4mkN8gMczD752I
         nUKIFLTUnqk+QVI7+uQwh+QvDZHNUDq2CZrrVPQmyOuoL08+DnxmHZlF+YgNu/IyXjU7
         XahGl9dFqedBsGHvGKLLqEWXcFXX7ZeKul3H4WjI8AIuvvoXoanMvpq96eVokzyjOQoa
         G0RkO4MnIDXkVoc2NTsakHGxAerxT9qHzWNCr8KtT2nDyfrugd5w7M9cM+WWQb61ZwXz
         nRCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFYZkIo54Vb6xPdnwSbUD94gNLUU6Se9+xaFSY96KbM5oTPVMevoxuJbW4IL1Xx5k+utY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDkuzPMACLHwBUbFLX0xXQcJ23OQ8l9XVU+DDICC+uVvk5JipJ
	m/ylZfhIfaMHBGI58aUnwuS19EYyCDoucl79WSZe9bqXbc5GxuSZSZqYtPBQjNYVshuVaLvQ1W5
	esSA6wSRc1S6+h1Q9Z3KwVBvyFhPEL47YaXY/BZ/B/iaxpCc1vg==
X-Gm-Gg: ASbGncufoS6B2hXG55iSRXIbuN4Hyn3D5LFsyNLkfBHyCHLGu0XvhLo8U+OKV1obg88
	vpU0UA+7SXTswUhh+USyiMQKd1pRqF0/yscXMIDVxgzhWbTz4skLSwHX/hZjpP/yL7JXCJhehl7
	quIEGYusxOmyxbv1drhoSAgqm+9NFq8K5f3f4JLFa+kDz2I7sxHyEvW8y/xLGkBo8y1oimRWwfG
	gfOVr8GwB6Ny67KEnxXlO53CgWKRBPjKA54/nl42ZsFGyyQQWSlh4JU/2MMZ5iGSm5QCck1C37k
	wkuw3JJFow==
X-Received: by 2002:a05:600c:190b:b0:43d:45a:8fc1 with SMTP id 5b1f17b1804b1-43db61e0327mr166905415e9.4.1743608407263;
        Wed, 02 Apr 2025 08:40:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFnFH42jKvsNA+QiJsZ/dd/OiaMejjhtC78pMe0Jb00FkOJVLLyR+cxJWkaCicl8B+/i2omrA==
X-Received: by 2002:a05:600c:190b:b0:43d:45a:8fc1 with SMTP id 5b1f17b1804b1-43db61e0327mr166905175e9.4.1743608406852;
        Wed, 02 Apr 2025 08:40:06 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb5fcd489sm24265995e9.11.2025.04.02.08.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 08:40:06 -0700 (PDT)
Date: Wed, 2 Apr 2025 11:40:03 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Halil Pasic <pasic@linux.ibm.com>
Cc: Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, stable@vger.kernel.org,
	Maximilian Immanuel Brandtner <maxbr@linux.ibm.com>
Subject: Re: [PATCH 1/1] virtio_console: fix missing byte order handling for
 cols and rows
Message-ID: <20250402113755-mutt-send-email-mst@kernel.org>
References: <20250322002954.3129282-1-pasic@linux.ibm.com>
 <20250402172659.59df72d2.pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402172659.59df72d2.pasic@linux.ibm.com>

On Wed, Apr 02, 2025 at 05:26:59PM +0200, Halil Pasic wrote:
> On Sat, 22 Mar 2025 01:29:54 +0100
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > As per virtio spec the fields cols and rows are specified as little
> > endian. 
> [..]
> 
> @Amit: Any feedback?
> 
> > 
> > Fixes: 8345adbf96fc1 ("virtio: console: Accept console size along with resize control message")
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Cc: stable@vger.kernel.org # v2.6.35+
> > ---
> > 
> > @Michael: I think it would be nice to add a clarification on the byte
> > order to be used for cols and rows when the legacy interface is used to
> > the spec, regardless of what we decide the right byte order is. If
> > it is native endian that shall be stated much like it is stated for
> > virtio_console_control. If it is little endian, I would like to add
> > a sentence that states that unlike for the fields of virtio_console_control
> > the byte order of the fields of struct virtio_console_resize is little
> > endian also when the legacy interface is used.
> 
> @MST: any opinion on that?
> 
> [..]


native endian for legacy. Yes extending the spec to say this is right.

-- 
MST


