Return-Path: <kvm+bounces-51796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 375E4AFD47A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 19:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DA8E1891E34
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 17:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0165B2E62C7;
	Tue,  8 Jul 2025 17:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRCIFICF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5072E62B3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 17:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751994028; cv=none; b=n3VHUBkFM2tm9tVI4YrRpgubiVkqMGLib7tCs0r15S3OYFLwyc8QiJrHxsudBo90BzP3+zOAETxKuGyqVmZES+kWgjPdKx/3xCv9DZY0piJ7vYmRDUjH6RlkRgHAGjwGSr11h6q8PF+yB4mNGNjt3Pkqg25VekOmqSXZfiEw7bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751994028; c=relaxed/simple;
	bh=vqmP40l2sQm+jo5YrbdEYj98+Uk19D7cUQ2Z6s1E4Hg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=i/stThoCcXjhlR+xGsR7Id4EVSBPk0sSXLoW7jheun2I+e12zh4fAOI3axHhBOioMj4pDkBfL1hYMX3trDJBku6X5iLFboKQUI2AYrir10Y3SX4lj2mgkFOzTev9qBXXfBQqfY1xhTdbWZ4XCMbSn96PyG/qvGZOKYsJ4zbQlQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRCIFICF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751994025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tOAUOdDQ/Ohpve7MT0b5vBpxcHJyYUTcEvYHV9S4P7A=;
	b=bRCIFICF5XsB/oDIzgV3QLq7cWOFEO1eB6oaFo4PE2es3nSz4eq23x8cFne1RSd6XN515C
	Dsw7XhkkY0+gEdZ4e9LEVIdM+0OB02Gm+/JbFXVGBCCFyzcWssK+0btDe5Kdf1ba+YPhTk
	RYRiHLmpdJ50gvVe9fWJatfnjaYY7iE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-120-LW9BeGdmMjaLtRmec_i2FA-1; Tue, 08 Jul 2025 13:00:23 -0400
X-MC-Unique: LW9BeGdmMjaLtRmec_i2FA-1
X-Mimecast-MFC-AGG-ID: LW9BeGdmMjaLtRmec_i2FA_1751994022
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-450d64026baso22953205e9.1
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 10:00:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751994022; x=1752598822;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tOAUOdDQ/Ohpve7MT0b5vBpxcHJyYUTcEvYHV9S4P7A=;
        b=v+V3KUso4d21LEjX54JNT3e10cVe4Lspf1dNc54O0QCIbhpf/CUHnfHWgT28m2lKwW
         qNnZN67s5KocUjCYS5gtiu4T6sMtmxL64jxS1G9Ly6bhW4bvY9awMwZsrRREqq5RYmAC
         GVi2chtTaDstfjn4szqe7017PpK3RiUxbD5XQJqd3CGkKcx8xGKloG3OsTPMRxmgVsQ+
         zcN9pMwwtKm/Xfkp7KXMQhDIV4AEjByaqm3HiDTjDTsBZo2R33xJ13ft1Y0ZTI3EuNp8
         PAw/4xB06VG5xHvFO9WJA5vSjvM/h47XJj+QVt77e12Gm/qAXr4N6ctKeyju9XsDHxph
         TBQw==
X-Forwarded-Encrypted: i=1; AJvYcCVe3IfS83u18FORLz+qvnxCDwxdC0gYo1hjIx4Vfvu4m+L4tRaD5E61okzcRJP9W+UPAP0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz11vC0kATqk2WJyZTawwH4usHJevFbCuz1eu0lbPs2GMuTcIbZ
	54tMlahU0Sl41MTsg3xlnXUbCdOYuXw1FWlSBe7JnSOTFfblkV2o4ZkN2isHMuzqmG1CoIvWdBy
	fSqYYBej1B5HTjayZABN76sRUfJoqHDB99t6QU9A7eAzfULwAa6/GxQ==
X-Gm-Gg: ASbGncuUU3acj+APdHCceK34XhuHjVAtn0sbQH8ZAEP3A3UQ5mc5vJTS+wurlZJcq4g
	tp0nV83kwtogyZGujoga9VXCmUVw552Lmwa0RNOmjhOJxjgjtCMoNHLlWwfccdB/8bOUkLnDP0R
	VkDvj0leGDru8l1TdHjjcj2o0O0U3jRl6AchivgRYtOnIeKOrPSWb34H7ak+fhICWrE5rVkwcvN
	rYSFB74k2awvUtlX52lAARF+BzaLQHgfsnOD2qMgjs+001VoaUEkFnmErAt6qGNmtUHAQfkM+xI
	b80lvUdgqcJQxKuNyif3jrz+K1xjZyjULfhcPX6pN7WmU1s5Q45W8pbtJmK8zABzwOoPRg==
X-Received: by 2002:a05:600c:1d1f:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-454d3564b66mr5873995e9.0.1751994021592;
        Tue, 08 Jul 2025 10:00:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEs2z8yosruby7WptbVhLXHCy2dc1fLMqvjmukcchZaNusQYuScrXtah/V+6PVdS+yzg4/ynA==
X-Received: by 2002:a05:600c:1d1f:b0:43c:e7ae:4bcf with SMTP id 5b1f17b1804b1-454d3564b66mr5873475e9.0.1751994021106;
        Tue, 08 Jul 2025 10:00:21 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:2717:8910:b663:3b86:247e:dba2? ([2a0d:3344:2717:8910:b663:3b86:247e:dba2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cd39d0f6sm27320025e9.16.2025.07.08.10.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:00:20 -0700 (PDT)
Message-ID: <ef9864e5-3198-4e85-81eb-a491dfbda0d2@redhat.com>
Date: Tue, 8 Jul 2025 19:00:19 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 net-next 0/9] virtio: introduce GSO over UDP tunnel
From: Paolo Abeni <pabeni@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, Jason Wang <jasowang@redhat.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Yuri Benditovich <yuri.benditovich@daynix.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>, Jonathan Corbet <corbet@lwn.net>,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1751874094.git.pabeni@redhat.com>
 <20250708105816-mutt-send-email-mst@kernel.org>
 <20250708082404.21d1fe61@kernel.org>
 <20250708120014-mutt-send-email-mst@kernel.org>
 <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
Content-Language: en-US
In-Reply-To: <27d6b80a-3153-4523-9ccf-0471a85cb245@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/8/25 6:43 PM, Paolo Abeni wrote:
> On 7/8/25 6:00 PM, Michael S. Tsirkin wrote:
>> On Tue, Jul 08, 2025 at 08:24:04AM -0700, Jakub Kicinski wrote:
>>> On Tue, 8 Jul 2025 11:01:30 -0400 Michael S. Tsirkin wrote:
>>>>> git@github.com:pabeni/linux-devel.git virtio_udp_tunnel_07_07_2025
>>>>>
>>>>> The first 5 patches in this series, that is, the virtio features
>>>>> extension bits are also available at [2]:
>>>>>
>>>>> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
>>>>>
>>>>> Ideally the virtio features extension bit should go via the virtio tree
>>>>> and the virtio_net/tun patches via the net-next tree. The latter have
>>>>> a dependency in the first and will cause conflicts if merged via the
>>>>> virtio tree, both when applied and at merge window time - inside Linus
>>>>> tree.
>>>>>
>>>>> To avoid such conflicts and duplicate commits I think the net-next
>>>>> could pull from [1], while the virtio tree could pull from [2].  
>>>>
>>>> Or I could just merge all of this in my tree, if that's ok
>>>> with others?
>>>
>>> No strong preference here. My first choice would be a branch based
>>> on v6.16-rc5 so we can all pull in and resolve the conflicts that
>>> already exist. But I haven't looked how bad the conflicts would 
>>> be for virtio if we did that. On net-next side they look manageable.
>>
>> OK, let's do it the way Paolo wants then.
> 
> I actually messed a bit with my proposal, as I forgot I need to use a
> common ancestor for the branches I shared.
> 
> git@github.com:pabeni/linux-devel.git virtio_features_extension_07_07_2025
> 
> is based on current net-next and pulling from such tag will take a lot
> of unwanted stuff into the vhost tree.
> 
> @Michael: AFAICS the current vhost devel tree is based on top of
> v6.15-rc7, am I correct?

Which in turn means that you rebase your tree (before sending the PR to
Linus), am I correct? If so we can't have stable hashes shared between
net-next and vhost.

/P


