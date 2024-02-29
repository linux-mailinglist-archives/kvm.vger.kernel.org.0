Return-Path: <kvm+bounces-10455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A8EA86C31E
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 09:09:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0941A1F231CD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:09:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F945482FC;
	Thu, 29 Feb 2024 08:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZIuDEOyy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE9F47F50
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709194131; cv=none; b=UT+xustCzmKxhcL+ksAFJLc65irQ0dv7G91pwY8R8oOIvlrj3A4qB6k1xTm86stqK5B63AJPRZZdV25btaEcexqNhO7uoqz8I01BBEdZSTtsnIH5cw44gR4HD9yAclFfab7k9FWyrjZ4yu4tjHDL7E8JJqCDzfWjXXafjvEQJCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709194131; c=relaxed/simple;
	bh=p2AucDcjwJAc5f/us8nHZQzK0FZ0x5K7PfiLkMlk26c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=npKCIJ1wEpe5AreMBhhJVqY1s8OlKkmDxQmvDSST6vabUf6JdqhW6nhBvF4WMumNS59TK5BEfHGpeqRickLLIR42H/YsQEy9T/wTg/3I35ATa7N4c7FPeLqxHI9Ys4qvpy8a3iBFAajzAprf3e+ayU0N1rDd9ZCN8q7Zv+rRKCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZIuDEOyy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709194128;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=15w6wj3J35usSWdRwfld/vYX5aTLUZWqSCkNcgI5sDA=;
	b=ZIuDEOyyKZxH2YzGwtOtE2uLkZ/D8LaKZBGiuwXelZkx6ilMsT7/DKL+A+JzSJG87T1I/v
	UIE/5arE23z6XAyeSgI6IbEbbPLjmE+rp5Nzgxf/szQGEwtPjP00aW92ZTzj3kypclUvn0
	GyZZPnJLQbbko1K0f2nmfbC9LmSFCTc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-8k6x6KdqPb2n54yzuuYDhw-1; Thu, 29 Feb 2024 03:08:46 -0500
X-MC-Unique: 8k6x6KdqPb2n54yzuuYDhw-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-566ae32611eso76745a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 00:08:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709194125; x=1709798925;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15w6wj3J35usSWdRwfld/vYX5aTLUZWqSCkNcgI5sDA=;
        b=faAaH94aLK0Cwcuk+YthMSfiyQFSfP43WuCdCfCIpW5DCb9ocld6UAwCqGyJO45cMU
         iB7VFe6ODcv3qVL2Vg0T5OEUFEN20VcXHvyGVjQTmgHpeQhcqMbIY5g/95U45soHMqdY
         6rZTZgBEMuC1IvbEVREI35xfk1M+sX/HXnvwIrNFmMj5Hs9gtKv/1aE32Yc2zZFSPYlD
         DABKTeQM71c8Owe3z9duRWFmkLyJx3AT7+2JgLc+zXeR+niv+gww9vIvhNYfQ99RPTZd
         dRk+BDh1FMZbPQ/OCtcHBFRyXQ0i3rdt7HbfOFpDDyw7wcXqmSeLF2xhZ+cl8+Del1CW
         QNDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWi4OUtZYjj6Sz9cHRERmAWisWqVMw7GhqiBEMoX7V4O23BSp+m/6sREVOd5Kk/A0pY75XE7gq9fo1zvaj4BJFgod97
X-Gm-Message-State: AOJu0YxuQ7W/fCUp+IFgCK/uOgFY+MBgZoUEiPTEUb5jZoOHJMm+z1NR
	PCAr7IjABy7FwzeEVX/Rmx/fxu0p0CC1zLl9UREbrehmVnANFcYqG61rsRJWRRSU2gS2IK2ZMcP
	yB7Av0L9ys1nWk4lHbGkwtuWEnRxGk3ne00da48BUF9Zk0K7DZy/FlzKbzZ/1V+Io/sNCwIG/u2
	Ip39HznCvM24gCMCYVtoUDC9QaMGEcIsRHXA==
X-Received: by 2002:a17:907:1deb:b0:a44:3dd:1a70 with SMTP id og43-20020a1709071deb00b00a4403dd1a70mr823117ejc.11.1709194125688;
        Thu, 29 Feb 2024 00:08:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHRmHLabCtfkOep1wbFTP3rLm0qXOdCtirtmFfOtY9v2jAX1oaNJwrNSFqOP0TRw9SJDaT04g==
X-Received: by 2002:a17:907:1deb:b0:a44:3dd:1a70 with SMTP id og43-20020a1709071deb00b00a4403dd1a70mr823096ejc.11.1709194125225;
        Thu, 29 Feb 2024 00:08:45 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id js9-20020a17090797c900b00a3d0a094574sm419645ejc.66.2024.02.29.00.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 00:08:43 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Greg KH <gregkh@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: cve@kernel.org, linux-kernel@vger.kernel.org, KVM list
 <kvm@vger.kernel.org>
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
In-Reply-To: <2024022905-barrette-lividly-c312@gregkh>
References: <2024022822-CVE-2021-46978-3516@gregkh>
 <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
 <2024022905-barrette-lividly-c312@gregkh>
Date: Thu, 29 Feb 2024 09:08:42 +0100
Message-ID: <87jzmnn14l.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Greg KH <gregkh@kernel.org> writes:

> On Wed, Feb 28, 2024 at 11:09:50PM +0100, Paolo Bonzini wrote:
>> On 2/28/24 09:14, Greg Kroah-Hartman wrote:
>> > From: gregkh@kernel.org
>> > 
>> > Description
>> > ===========
>> > 
>> > In the Linux kernel, the following vulnerability has been resolved:
>> > 
>> > KVM: nVMX: Always make an attempt to map eVMCS after migration
>> 
>> How does this break the confidentiality, integrity or availability of the
>> host kernel?  It's a fix for a failure to restart the guest after migration.
>> Vitaly can confirm.
>
> It's a fix for the availability of the guest kernel, which now can not
> boot properly, right?  That's why this was selected.  If this is not
> correct, I will be glad to revoke this.
>

To be precise, this issue is about guest's behavior post-migration and
not booting. Also, it should be noted that "Enlightened VMCS" feature is
normally not used for Linux guests on KVM so the "guest kernel" is
actually Windows kernel (or Hyper-V) :-)

Personally, I don't see how this particular issue differs from other KVM
hypervisor bugs. I.e. when hypervisor misbehaves, the guest will likely
suffer and in many cases "suffer" means crash. What *is* important is
who can trigger hypervisor's misbehavior. In case it is guest triggered
(and especially if triggered from CPL!=0), security implications are
possible. In the even worse case when such guest's actions can cause
issues in the host's kernel, the presence of a vulnerability is almost
certain.

Migration is (normally) not guest triggered, it's a deliberate action on
the host.

-- 
Vitaly


