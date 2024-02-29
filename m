Return-Path: <kvm+bounces-10549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4447086D591
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:05:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C975E28BE37
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 21:05:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CEC574BFE;
	Thu, 29 Feb 2024 20:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FpoHLgzV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D14C74BEF
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 20:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709240032; cv=none; b=CvLoOq+N6/U0drxMMRtCWTA8feKEUNACAaxaS9RUCIOQmElJYax1uIC8g10m7SI1cZHHgbfvNa38QE+1JOrH2OdOEs1VbC8C5Eb6qEAxvUKQ34B3kX7idXEcpY4OHQZhL6x6FO8iffvbTasNCXFS3jsNbCII9+EjYtFpoaaEIdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709240032; c=relaxed/simple;
	bh=aSfCidGWZQymlsm3BsMfr0uts4B7cslkQpccMqtTIlU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q2VRq3BG5haJc/W/pwRcxdU6+nsspgJ2WG+B7oGGVEaLIwL7lIT2ViGDQO0SDcghqL5r5wMap60ealQ9zMNQxuXOs9LQxSctnwaT182JENvouC/F7PFdJ5CTR3nJcP3W2C2kiSgAerLvMbdMsjrRfDBnvyiENi/Q6FoUo0PeqCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FpoHLgzV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709240029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pwC7w8RQ315Hy8ZjgqKPWOY3T5YPFeI5JvaDoZSl2GE=;
	b=FpoHLgzVcto67Kcnqwa0sZKH4arGrKuhzupCc2M1O7hgygpOzRVm1yq+3wdYqrL5o90zLU
	U4P5Q4CqPgUyQNEvq1az0m19eV4XWGVe9BXfv7xyq34JCMLatt6Okm2jYJKVVC5VyRDGX1
	wgvPoJ+piVMtvkgf5e1dZOOWRf/Zvuw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-x3ywzNeDNvmhBOuzqYb3zQ-1; Thu, 29 Feb 2024 15:53:47 -0500
X-MC-Unique: x3ywzNeDNvmhBOuzqYb3zQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-56421fd7029so1000235a12.3
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 12:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709240026; x=1709844826;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pwC7w8RQ315Hy8ZjgqKPWOY3T5YPFeI5JvaDoZSl2GE=;
        b=xNhv/fmKld92ImQSn8sIYG/lx+G6mPRwZFKoGre+xYyvabheoP++1baI27nWoAzwAY
         yFRaSdF/nuqL11VYmTXcCqvZbchD2XSPGp2WwL/ZhXj1r/9ht9n5CXdp59mvF7Amasgn
         qC9EF+3QBaYo804HzN/sdS7lwZah4tQeBjrpyKhvXhLnFRQ6BLRXjjfEdvy6JJjq1cUP
         8GW568SzyFjO7uU7tl/K6dxdI+3oid04xmVTO950FtrKhfJXgvVYoGU1Fjfm52wCEWwr
         v+bjrmDorWu5qRG0Un6gyEGE0aw0CPz3wvBxXlGQ1cAEXT+/0d5RWLiYTVxSQC83S9Ue
         YGYg==
X-Forwarded-Encrypted: i=1; AJvYcCVvkFt+h2jcXHgecE64XMBqRiplsO2XFbVMhjb722EWOm/6zG41ZTCSLGD8LaBOpx8LFyPjU/B2F+8hRB8EgqHPaavG
X-Gm-Message-State: AOJu0Ywskx/UZ0oK7Hj2WJgrwvJzXuB1wAEnN7zj1n0N0ZYZbt1JCz7I
	QEc7C0hLaUMfWEzomKmHHTHt/yTl0OeZAkhrcOiRMwcZwVDGEtokj5az4Kw9yV2RFjQ9AyvPkEa
	qS92cT/YlKpK4ObYUsF8w5uNKxT1TSBJ/SosZ05roYTDH4CYttA==
X-Received: by 2002:a50:85ca:0:b0:565:7733:3c58 with SMTP id q10-20020a5085ca000000b0056577333c58mr58408edh.4.1709240026736;
        Thu, 29 Feb 2024 12:53:46 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEOZ2cLSgzAhYyDA6LLyzzJ+clnn6kc1PAWLDoUQN+uKtntvl2GL/JHid/8tMXrs0ACpLPt7A==
X-Received: by 2002:a50:85ca:0:b0:565:7733:3c58 with SMTP id q10-20020a5085ca000000b0056577333c58mr58405edh.4.1709240026415;
        Thu, 29 Feb 2024 12:53:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id es17-20020a056402381100b005666aaf340dsm925739edb.21.2024.02.29.12.53.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Feb 2024 12:53:45 -0800 (PST)
Message-ID: <f25bc125-a013-4c43-b67d-09512786ae90@redhat.com>
Date: Thu, 29 Feb 2024 21:53:43 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
Content-Language: en-US
To: Theodore Ts'o <tytso@mit.edu>
Cc: Greg KH <gregkh@kernel.org>, cve@kernel.org,
 linux-kernel@vger.kernel.org, KVM list <kvm@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <2024022822-CVE-2021-46978-3516@gregkh>
 <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
 <2024022905-barrette-lividly-c312@gregkh>
 <CABgObfZ+bMOac-yf2v6jD+s0-_RXACY3ApDknC2FnTmmgDXEug@mail.gmail.com>
 <20240229143454.GC272762@mit.edu>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240229143454.GC272762@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/24 15:34, Theodore Ts'o wrote:
> On Thu, Feb 29, 2024 at 11:04:45AM +0100, Paolo Bonzini wrote:
>> Also, LKML does not get the initial announcement, which makes it a bit
>> more painful to find the full discussion on lore (you have to go
>> through a "no message with that id, maybe you mean this one from other
>> mailing lists" page, instead of having the whole thread in the same
>> place). A linux-cve mailing list with public posting, used for Cc and
>> Reply-to of the initial message, would solve this issue as well.
> 
> I believe the url https://lore.kernel.org/all/<message-id> will get
> the whole thread, regardless of which mailing lists individual mail
> messages were sent to, does it not?

Yes, it does.  That covers the web interface but it still leaves out 
subscribers and people reading via NNTP.

That said, I'm not sure why people who look at CVEs for a living should 
not have their own lighter-traffic mailing list, which was the main 
reason to have a linux-cve mailing list.

Paolo


