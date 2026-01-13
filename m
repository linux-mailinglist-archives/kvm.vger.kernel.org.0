Return-Path: <kvm+bounces-67956-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B42AAD1A4DB
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 17:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB3D3301A4B2
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 16:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA59309DB5;
	Tue, 13 Jan 2026 16:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CrVsbU7q";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SYy9k/EH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBD43033C1
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768321859; cv=none; b=ICnMg8KH3mMdMjThb56swsHmRktjoHgUBS9fY9XA3zI5T8L08zAmtUy6/H9eQEN382vaGPqjHJ100/3IYHaBb5Xu7MhEsSmo4aCM8oDyE+3WErvZG/+sewyFzSkgZqIIrPOavePFFsZHgktcW4/ylq9GgrYhw3qLIPviULMBc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768321859; c=relaxed/simple;
	bh=qEdv/fe50Q3FodgzQpU3W0mGwjaiPPgk9rVlYqrsPrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhFLA/wYeuoeA8sNLtpM0bb5Q26oVo7+QsjKBZcGFtgKUc/qxr50ZNMRXFCRe2bWo6U2QdCqoCHORslsQ/nos0v1F+m9PYZ2bwQAkAcNF5bOzGvscPk2acjNxStA9ulEqQiatwpKy5ColjimLXQkVW+4rrTAtXKtlFgLUiDJH1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CrVsbU7q; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SYy9k/EH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768321857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=boQE4q0KM6aYzkUDuqPLA1uwKPn46HvgGbqZIDctbEE=;
	b=CrVsbU7qDbKr442sB8VqK0Fxu8Sk7MN4BY2Wlizmc3Ovv3kOu9TO5B9rbA1xAXhQlnOxUe
	VGbKeV0C4Z3w8qkrLtci2V2/ay2+g/y2+hogCp5zpdRsMBoT4xsG1/LK6Z8fXvwLSrZTAv
	nvuyiI8R5ovCe47P41HtKlSGf/BCr9Q=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-z3hKBMSvOXKtxHQL00Aabw-1; Tue, 13 Jan 2026 11:30:55 -0500
X-MC-Unique: z3hKBMSvOXKtxHQL00Aabw-1
X-Mimecast-MFC-AGG-ID: z3hKBMSvOXKtxHQL00Aabw_1768321855
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8c1cffa1f2dso1803014885a.1
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 08:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768321855; x=1768926655; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=boQE4q0KM6aYzkUDuqPLA1uwKPn46HvgGbqZIDctbEE=;
        b=SYy9k/EH+4bBqtParPBZhCCzYfPayoQ7mOQfE+U/OD8IMsq/azMQHOZZKnhAedWnW1
         IL/hqXDdYL5TB0g1s2RCF06SmAk1wKqvBnl+KqflJy09MFa01nYCA9afPp/YMuboc4r/
         nCv2aoUjngHoAfFq8qUSKxOboaDc6ySyqVa18IIVnwljYwxEeZWpqWSwiQNmVJ1dbagV
         /55sz+wXpw5jje8tAocJxzAw/H5Iwb0XPR6iB+sSsZgEaPC6J+197fc/XduMTX6yplhK
         jFwbinM+xbX0WjP+7TG4OcvdkKVQALedPNOrxYrQ53YHQ1w/qG9ZcRVdHb50VuVFLWs2
         mnyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768321855; x=1768926655;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=boQE4q0KM6aYzkUDuqPLA1uwKPn46HvgGbqZIDctbEE=;
        b=JlDHnphwpHLqp5MUQsDpLmsO0DoYlsZL7SBxorWrUfiNPJH+0R9EpAe/0wcWVtjT0g
         j/KuG6jrRVK3r2kZwE13D5k8fcK3LYl6AZpTx1xdvNAWne6XT1yju9s7ALmmE81oWsqN
         JdnezaHBzjrv83nN8wR4CUKxQCuXF1Ix1jvBnTWn+BwOsnInAjsZqb7M6mnBQ/rC4p4O
         T51hMdrC/UNiNJrnh1lzJSWZiUKHFUrIvhR2ZrGsboVcHsJBHbM6BrsBFVFdQIh15GVK
         bmqhcegZLC0RR2WBkDcMKszX7jDcy6CUfRLEhhIDuMkGumjE5QtgeZzmIJW0eHcZAxXZ
         i1zw==
X-Forwarded-Encrypted: i=1; AJvYcCWAD0lZviMftElKHrEHo8FGDX+5LaVgs4xn262NQe23GFAVaiSMrS8xNO8/yQjsefQ0PPM=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmc4Ga66FEPnFmXfk5nHSVyVRVMTVGvQprpNt66VKVCUllBNcJ
	PUCUHF5pSuPlDHLnOCxFlawsA5ko/w2rf5EOGZ7s2nreeJBVow5Cfoa2NVxDr+ikF3aBu75QcXM
	bI2R04WF5dTNl64Z+ywW2RiIf0WTTuQBQIOpwZ3/qFtpffKRTmnNLLQ==
X-Gm-Gg: AY/fxX6FkSdf1AyxqdNRkHLxp7Tx4HdcBY3eHAkXdQLAsR1qNAahwvPx0lVblD4qR8E
	li4F8Fa1UFaXZJPgqvP23b5toaaKVifuSuWi9RwJQaoETG0y3xove53gEQDoEyH874u9bejnpJv
	7h2nSmtQ8urpCBFuj3yH9aWGZL4rKbIGhd62QT2fPNFbQvLxCNS5d6CbC9rNqKi6+rKJ/vKFGB0
	v2IWRc+W8n+XsSOPL4b0SYQVW3h9xdfA1qfjJGWkgwOxkakNZQ8bGb5gjDnRBjoyCoANHwtHdL2
	WGl90xS1EXFWP+naiEjfNXuMhu9C8CvDfA1ONxDv097GmNrF84Dg1huG8oJqI4l+cERtcAtcf17
	fNPw=
X-Received: by 2002:a05:620a:1a13:b0:8b2:ea3f:2fa4 with SMTP id af79cd13be357-8c52082ba2cmr467695685a.6.1768321854374;
        Tue, 13 Jan 2026 08:30:54 -0800 (PST)
X-Received: by 2002:a05:620a:1a13:b0:8b2:ea3f:2fa4 with SMTP id af79cd13be357-8c52082ba2cmr467686585a.6.1768321853745;
        Tue, 13 Jan 2026 08:30:53 -0800 (PST)
Received: from x1.local ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89077267e14sm160158686d6.49.2026.01.13.08.30.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 08:30:53 -0800 (PST)
Date: Tue, 13 Jan 2026 11:30:51 -0500
From: Peter Xu <peterx@redhat.com>
To: Stefan Hajnoczi <stefanha@gmail.com>
Cc: qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>,
	Helge Deller <deller@gmx.de>, Oliver Steffen <osteffen@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Matias Ezequiel Vara Larsen <mvaralar@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>,
	German Maglione <gmaglione@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	=?utf-8?Q?Marc-Andr=C3=A9?= Lureau <marcandre.lureau@redhat.com>,
	Thomas Huth <thuth@redhat.com>, danpb@redhat.com,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Alex Bennee <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Marco Cavenati <Marco.Cavenati@eurecom.fr>,
	Fabiano Rosas <farosas@suse.de>
Subject: Re: Call for GSoC internship project ideas
Message-ID: <aWZzOz9hlvdRDj13@x1.local>
References: <CAJSP0QVXXX7GV5W4nj7kP35x_4gbF2nG1G1jdh9Q=XgSx=nX3A@mail.gmail.com>
 <aWZk7udMufaXPw-E@x1.local>
 <CAJSP0QVm41jSCma73sef7uzgEnqESRfqrxRstNTY_pd4Dk-JXA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJSP0QVm41jSCma73sef7uzgEnqESRfqrxRstNTY_pd4Dk-JXA@mail.gmail.com>

On Tue, Jan 13, 2026 at 11:16:27AM -0500, Stefan Hajnoczi wrote:
> On Tue, Jan 13, 2026 at 10:30 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Mon, Jan 05, 2026 at 04:47:22PM -0500, Stefan Hajnoczi wrote:
> > > Dear QEMU and KVM communities,
> > > QEMU will apply for the Google Summer of Code internship
> > > program again this year. Regular contributors can submit project
> > > ideas that they'd like to mentor by replying to this email by
> > > January 30th.
> >
> > There's one idea from migration side that should be self-contained, please
> > evaluate if this suites for the application.
> >
> > I copied Marco who might be interested on such project too at least from an
> > user perspective on fuzzing [1].
> >
> > [1] https://lore.kernel.org/all/193e5a-681dfa80-3af-701c0f80@227192887/
> >
> > Thanks,
> 
> I have edited the project description to make it easier for newcomers
> to understand and added a link to mapped-ram.rst:
> https://wiki.qemu.org/Google_Summer_of_Code_2026#Fast_Snapshot_Load
> 
> Feel free to edit the project idea on the wiki.

Looks good, thanks Stefan.

-- 
Peter Xu


