Return-Path: <kvm+bounces-18684-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D25D08D8830
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 19:49:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 635001F21FEF
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 17:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A980C137924;
	Mon,  3 Jun 2024 17:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmomtV2F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6134820317
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 17:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717436955; cv=none; b=iy48pHU7qxsEckxlebnsqAbWu2zgCI96F8//o9FS7AQkI9T+F2ouutNFURy0yj/LOt8cGQSFZ/BTsjonSGBjcPxKX1tnCb0MDBi9YT7LRhP75G+kRSrB3IxP4HcqOHjfpcnPK01gPTfaTi+1FuUfxZOcRU+0Edcnuw8LvBYvVvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717436955; c=relaxed/simple;
	bh=7pq+mrMwvLBFZADeatj0Ey/LYq4r6t2MQXlslo6vaJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H42mw+mCu4JrjDF9q4aIn/271MIuqveSscvf/z2zgcYKEoYsuT+hXGUhBmqr9DqK/0bT/NuNzsrxjD22SwQwiAob4ApXzGjzrah+298Xq6II+QBplipCLnKQU30ilpUkfpEFCKINI8vAkF85igRgQeJbxaCSs008mK/k1hHA0XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WmomtV2F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717436953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J3WmsIAxY9dZI8Ob+M+L7GaWD2FuzMHbC9UiUaK29h8=;
	b=WmomtV2FwSXbJ5UTCg7x+K0hR/yn4M/pLLel0hrC4c/PLcHaEe6yWOA57sWImNf/Q3en+s
	CnYabeLqdXE5TJE9+Nl2ACHkZf1gQhcHeS30QwbxndmMpDAWod3SYOvAOvqDdtWRfXw5nb
	i1ziFz8h+XoAdI8jYooEBcaiJ5HKHGs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-TpE-C-lpOkmUxO3jw8xqjQ-1; Mon, 03 Jun 2024 13:49:11 -0400
X-MC-Unique: TpE-C-lpOkmUxO3jw8xqjQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4212e3418b1so19470205e9.0
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 10:49:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717436949; x=1718041749;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J3WmsIAxY9dZI8Ob+M+L7GaWD2FuzMHbC9UiUaK29h8=;
        b=C1WNirzQL28aPRhsDfanaDs4yXVoq/PhdCnRunBLVBy8RneGy6O8M7SJwpLXGqcjKD
         fNZzp39qPZmogKGJ6RH/VrtDxXI3km6yILHoVsgl0igTTwbqInqSCK/8usGwY9Eh108X
         5Dd+oZlh24iMC/zoxklcF+Wrv1HwxjgJ/UCtdWeFp2hxbLNnYdKtF0zM86jlFhgYfyzo
         VuQJTCcRDxlH0vzqpG7yr4voutqelNHHcwRpp5yAtBouXcMvNW3aDJ0/vqpGtoIKqX/m
         let2Wt4osz0OvsAUzW38kPwInlW0crngKTvIbG2UsI7m7YT0UCz21diIQPG0p/Y2Q3IR
         DSMw==
X-Forwarded-Encrypted: i=1; AJvYcCWGRtD4lc4WrH47TKUaE8k5poXwlg8ILLZ1BSzvEnbjfMXoQ6XDYagnt/JiLFByJmKHqIdE3j+FE8IVsHnMhA8VpzH+
X-Gm-Message-State: AOJu0YxRHwazpOL7uiyK6z5eld9PfzYP7v+mOA+Bfh8Y3PmB7fJpPCT5
	wGz8/kcmJ8IBgv6EytGTMpckRgfhPJXzgIq9hMaW24HNEs5WBNfvD8CZjXbRsWd7UEk/PDrf4KC
	bWVCLEuyduTExOMRuHapNUhRLm3XxLkzPgCclmO7Xyuq01U1ghLqekhoJyvCMCgNkMKCfj4uPg7
	WJeke3A4nke6kDTpsH/CPVxPMo
X-Received: by 2002:a05:600c:35d3:b0:421:3979:8c56 with SMTP id 5b1f17b1804b1-42139798e83mr35575885e9.40.1717436949764;
        Mon, 03 Jun 2024 10:49:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGbqFSwLkxs+GBeIocBtExiVcPfbKM6EgGyLF1m1MX6JOlzDCzjAQE9DJuLFvOa78ksAYM5/5f36+d6Gk1jfME=
X-Received: by 2002:a05:600c:35d3:b0:421:3979:8c56 with SMTP id
 5b1f17b1804b1-42139798e83mr35575655e9.40.1717436949399; Mon, 03 Jun 2024
 10:49:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
 <20240530111643.1091816-8-pankaj.gupta@amd.com> <Zl2w6KktLnFxq83Y@redhat.com>
In-Reply-To: <Zl2w6KktLnFxq83Y@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 3 Jun 2024 19:48:56 +0200
Message-ID: <CABgObfZwvvMRas2nbrOQiqKOpaLOVhqPxbY1eezrSxya-Z9mgw@mail.gmail.com>
Subject: Re: [PATCH v4 07/31] i386/sev: Introduce 'sev-snp-guest' object
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, qemu-devel@nongnu.org, brijesh.singh@amd.com, 
	dovmurik@linux.ibm.com, armbru@redhat.com, michael.roth@amd.com, 
	xiaoyao.li@intel.com, thomas.lendacky@amd.com, isaku.yamahata@intel.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 3, 2024 at 2:02=E2=80=AFPM Daniel P. Berrang=C3=A9 <berrange@re=
dhat.com> wrote:
>
> On Thu, May 30, 2024 at 06:16:19AM -0500, Pankaj Gupta wrote:
>
> > +# @policy: the 'POLICY' parameter to the SNP_LAUNCH_START command, as
> > +#     defined in the SEV-SNP firmware ABI (default: 0x30000)
> > +#
> > +# @guest-visible-workarounds: 16-byte, base64-encoded blob to report
> > +#     hypervisor-defined workarounds, corresponding to the 'GOSVW'
> > +#     parameter of the SNP_LAUNCH_START command defined in the SEV-SNP
> > +#     firmware ABI (default: all-zero)
> > +#
> > +# @id-block: 96-byte, base64-encoded blob to provide the 'ID Block'
> > +#     structure for the SNP_LAUNCH_FINISH command defined in the
> > +#     SEV-SNP firmware ABI (default: all-zero)
> > +#
> > +# @id-auth: 4096-byte, base64-encoded blob to provide the 'ID
> > +#     Authentication Information Structure' for the SNP_LAUNCH_FINISH
> > +#     command defined in the SEV-SNP firmware ABI (default: all-zero)
> > +#
> > +# @auth-key-enabled: true if 'id-auth' blob contains the 'AUTHOR_KEY'
> > +#     field defined SEV-SNP firmware ABI (default: false)
>
> In 'id-auth', 'auth' is short for 'authentication'
>
> In 'auth-key-enabled', 'auth' is short for 'author'.
>
> Shortening 'authentication' is a compelling win. Shorting 'author'
> is not much of a win.
>
> So to make it less ambiguous, how about '@author-key-enabled' for
> the field ?

Good idea.

Paolo


