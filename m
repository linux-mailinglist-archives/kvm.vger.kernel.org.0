Return-Path: <kvm+bounces-26544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D1A9756FB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 17:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D23F1C23196
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 15:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0882D1AB6F0;
	Wed, 11 Sep 2024 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="trLgU7bi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D492C1A2
	for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726068350; cv=none; b=j+A5SvfFZnBIwNmk9kcN29blH6s7gsJgpTq6RG0hCAi9qZ+9iUE5jhXo9V9YYMo3/MUhdXv1gZYcIgn7jai/M5lsuL16kCPMHigDLV9AqhmgLjZE0JvRzhhtJRUZwbBX6ADdIbhkr0Rki28J11hhwPDLCkr9p5uPW04g9axB7B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726068350; c=relaxed/simple;
	bh=S5SzwhIlKOYZtr7haBuKmPMl5xwsC0RCFD0a+O/dVFg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mi6pC/knrKBeYW3YIphmlhiBAgeeAtQBlmaP5/VbeCXIt7zY9WwEw3GNuDKwTmYBBXc/ImkQ99wzyaE7dUvxfn6+xVbOAViJmbQfPuTGDuHd0WeyxYBN/8oVa/O56jL1Syma7clQDLsQPMe6IP4Bcn5ZUz0rkKZGXJc+zF60lMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=trLgU7bi; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2068acc8b98so64256425ad.3
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2024 08:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726068348; x=1726673148; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KOIqyxflpQF2OIgg5Cs8RejsCarR4kHtT8bNPVM50WU=;
        b=trLgU7bil48a1SEeDZuZHXOHId+E73LJRFG16zCYd3DdFI0WIE+wllMFaANMhxbwtO
         /RIeQzqDEyZ1vIxoKvMjFhvzVDfSGXD0hbfzXfndoIb/eHPsFBIV40mxKx0j48vkYlu/
         LXFNGaa/Qnv5/Zc28X5GD9MaTK9R3NuLrlKJjp9Nv7tTFcyOnB93bWcT6QJqud8jqkDh
         R2/MWV3uNDGUuSm7CcL3vn9VSkyzNSkwDp8lMcuSCXWlka3XUVskNnc88sJ5PzB1Ajsj
         Ih11NWuAsy8XWm1WRB4OogOs7buBVmJ9Qk6nhWDQ35u3Lnx18rgkppxN5wT3G41mJmXU
         0e3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726068348; x=1726673148;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KOIqyxflpQF2OIgg5Cs8RejsCarR4kHtT8bNPVM50WU=;
        b=ZiWVGRvxikxMoXn23XmSOfdox28lzfXUDnMlQCZx5SC7pGqWeD8wl3eozD4e6uLnTU
         IvKtD3aYMCg7qIy4LpZzyuHynbNAlHjdeqTynMUAczH1Hmp+/hw/qeGQmGIIX3F735+/
         hTCvI+0mzehmJ/b4qs3ofDi9OEjsPpcxEd09wHmOk/Pa80+2q1xOa8x2voADnUXTbfam
         4SKv+7P/gUnuRTSYPBx5ZVqFYj0r0ZiYzQAsSU1ZFdm85NtxO8PQKywqMliCDHvsjLEX
         FbRtMq1fn4W0Z0WTTuqzwLa2mTxsjplRrdd9UBIRo4fnAXUPBdS/BGS+66KqM/47X8Hx
         b0yg==
X-Forwarded-Encrypted: i=1; AJvYcCXJL18MrRzLta2vULbqREbTJ8JWv7znb0Q2K2QNVjNNqc+hoBNaFEZbEZOVQtAZcghMiQ4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7S8SfAAb7AVvI5W5I/mZXRghyWzVavtPTh/DtPFimRhItz150
	kG3zd/cirHo9qsoDYqwhYd2NcrQ84ahHRKGMt5P/SQAvpiKVttRa24Nmh+KkjQ4=
X-Google-Smtp-Source: AGHT+IEo3j0LjjLmX6e/pgB28NMglTb3qohZUhTxnnknsMeupJHRg8k/VIdzXloihGE5TJFpijhPog==
X-Received: by 2002:a17:902:d54f:b0:207:db0:cb6c with SMTP id d9443c01a7336-2074c612765mr72854645ad.34.1726068347907;
        Wed, 11 Sep 2024 08:25:47 -0700 (PDT)
Received: from ?IPV6:2604:3d08:9384:1d00::9633? ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2076af25407sm1022925ad.41.2024.09.11.08.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2024 08:25:47 -0700 (PDT)
Message-ID: <6818337d-ba58-4051-8105-05f679f71b88@linaro.org>
Date: Wed, 11 Sep 2024 08:25:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/39] docs/spin: replace assert(0) with
 g_assert_not_reached()
Content-Language: en-US
To: "Richard W.M. Jones" <rjones@redhat.com>,
 "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Eric Blake <eblake@redhat.com>, qemu-devel@nongnu.org,
 Zhao Liu <zhao1.liu@intel.com>, Joel Stanley <joel@jms.id.au>,
 Kevin Wolf <kwolf@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 qemu-arm@nongnu.org, Corey Minyard <minyard@acm.org>,
 Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
 Keith Busch <kbusch@kernel.org>, WANG Xuerui <git@xen0n.name>,
 Hyman Huang <yong.huang@smartx.com>,
 Stefan Berger <stefanb@linux.vnet.ibm.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Markus Armbruster <armbru@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, qemu-riscv@nongnu.org,
 Ani Sinha <anisinha@redhat.com>, Halil Pasic <pasic@linux.ibm.com>,
 Jesper Devantier <foss@defmacro.it>, Laurent Vivier <laurent@vivier.eu>,
 Peter Maydell <peter.maydell@linaro.org>, Igor Mammedov
 <imammedo@redhat.com>, kvm@vger.kernel.org,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>, Fam Zheng
 <fam@euphon.net>, qemu-s390x@nongnu.org, Hanna Reitz <hreitz@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>, Eduardo Habkost <eduardo@habkost.net>,
 Laurent Vivier <lvivier@redhat.com>, Rob Herring <robh@kernel.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, qemu-block@nongnu.org,
 qemu-ppc@nongnu.org, Daniel Henrique Barboza <danielhb413@gmail.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Fabiano Rosas <farosas@suse.de>,
 Helge Deller <deller@gmx.de>, Dmitry Fleytman <dmitry.fleytman@gmail.com>,
 Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
 Akihiko Odaki <akihiko.odaki@daynix.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 David Gibson <david@gibson.dropbear.id.au>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Yanan Wang <wangyanan55@huawei.com>, Peter Xu <peterx@redhat.com>,
 Bin Meng <bmeng.cn@gmail.com>, Weiwei Li <liwei1518@gmail.com>,
 Klaus Jensen <its@irrelevant.dk>,
 Jean-Christophe Dubois <jcd@tribudubois.net>,
 Jason Wang <jasowang@redhat.com>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
 <20240910221606.1817478-2-pierrick.bouvier@linaro.org>
 <zkyoryho5alnyirnl7ulvh5y6tkty6koccgeygmve42uml7glu@37rkdodtlx4f>
 <bwo43ms2wi6vbeqhlc7qjwmw5jyt2btxvpph3lqn7tfol4srjf@77yusngzs6wh>
 <10d6d67a-32f6-40fc-aba9-c62a74d9d98d@maciej.szmigiero.name>
 <20240911125126.GS1450@redhat.com>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20240911125126.GS1450@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/11/24 05:51, Richard W.M. Jones wrote:
> On Wed, Sep 11, 2024 at 02:46:18PM +0200, Maciej S. Szmigiero wrote:
>> On 11.09.2024 14:37, Eric Blake wrote:
>>> On Wed, Sep 11, 2024 at 07:33:59AM GMT, Eric Blake wrote:
>>>> On Tue, Sep 10, 2024 at 03:15:28PM GMT, Pierrick Bouvier wrote:
>>>>> Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>>>>> ---
>>>>
>>>> A general suggestion for the entire series: please use a commit
>>>> message that explains why this is a good idea.  Even something as
>>>> boiler-plate as "refer to commit XXX for rationale" that can be
>>>> copy-pasted into all the other commits is better than nothing,
>>>> although a self-contained message is best.  Maybe:
>>>>
>>>> This patch is part of a series that moves towards a consistent use of
>>>> g_assert_not_reached() rather than an ad hoc mix of different
>>>> assertion mechanisms.
>>>
>>> Or summarize your cover letter:
>>>
>>> Use of assert(false) can trip spurious control flow warnings from some
>>> versions of gcc:
>>> https://lore.kernel.org/qemu-devel/54bb02a6-1b12-460a-97f6-3f478ef766c6@linaro.org/
>>> Solve that by unifying the code base on g_assert_not_reached()
>>> instead.
>>>
>>
>> If using g_assert_not_reached() instead of assert(false) silences
>> the warning about missing return value in such impossible to reach
>> locations should we also be deleting the now-unnecessary "return"
>> statements after g_assert_not_reached()?
> 
> Although it's unlikely to be used on any compiler that can also
> compile qemu, there is a third implementation of g_assert_not_reached
> that does nothing, see:
> 
> https://gitlab.gnome.org/GNOME/glib/-/blob/927683ebd94eb66c0d7868b77863f57ce9c5bc76/glib/gtestutils.h#L269
> 
> Rich.
> 

Interesting.
At least gcc, clang and msvc are covered, this should be ok for most of 
the builds.

Thanks for sharing,
Pierrick

