Return-Path: <kvm+bounces-1936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D66607EED8E
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 09:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9016D280F95
	for <lists+kvm@lfdr.de>; Fri, 17 Nov 2023 08:31:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57F1312E58;
	Fri, 17 Nov 2023 08:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qtqm9D7L"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92435199C
	for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 00:30:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700209832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ecl6gR/j9l4tmwy6aDtejNzjXal2h/loVpF3cjPsjz4=;
	b=Qtqm9D7LFBCS5UehPg9i1NdjTjsiG0DU2532MnVRsHpRF7KwGe/VNkPe/SdEiwnix+EY0P
	YYNFCC56mxIPfK6WN+xjVE8wYGbHJ9BdX9Puu5JwGTfu3OAec2iCnn8Nvdn/LMysmIgdrs
	GQ4+SKPB+8m7iyfeqgiER8SeMc7Xm9E=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-178-mZapLxyxNcGY0oBPMI27nQ-1; Fri, 17 Nov 2023 03:30:29 -0500
X-MC-Unique: mZapLxyxNcGY0oBPMI27nQ-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-9e644d94d84so121447466b.1
        for <kvm@vger.kernel.org>; Fri, 17 Nov 2023 00:30:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700209828; x=1700814628;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ecl6gR/j9l4tmwy6aDtejNzjXal2h/loVpF3cjPsjz4=;
        b=qVKacLeUfNr1A0ys+3+RAaQoJOT/6BQ42LHqcrHZ49W0jSRSzLTVnthF5R0MKEl69L
         m47fq/+SCvyOcgaBdbexMEtRMZ+SblXQRMdYALOmbfFAGVs+EbaWhazj3zPs3opImm7t
         IVYq2Zgw7qDTUv4ji8xm12ySXw8Iby9IQglu5WLwpBe/neD3d24fPBz0d5KKbUG+WGpH
         05mksjcC0SfovtXyQR1/9hTFpi1Y254m4HxwoBf2W57zi5AL/6ucbpA5WtZuc3nQwzJP
         dG0rprpOSAQ+3osKTqw6NTOwtZMMe1VNpebQWA//r9X+GDAc7bDzHTbMSR2mC3eNVgW2
         2BbQ==
X-Gm-Message-State: AOJu0Yy3qCZbYydKuKLUWAotVjRXVKlsnAw8ollXo9p0/qp4UQS3+flI
	soff3WdmD43VUxx/3C2TGPRqCOy0/9g8h7zAiK+m3ev9vYuIvc63blvRjAJ9VxQaIHrGxt1kDDp
	IWZomg75jxpL7
X-Received: by 2002:a17:907:b9c3:b0:9f3:18f8:475b with SMTP id xa3-20020a170907b9c300b009f318f8475bmr6952578ejc.62.1700209828357;
        Fri, 17 Nov 2023 00:30:28 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFPEAnGCm1WVzr07XAT0pN1kw24RqLiQT9EjkeoYuqTICFcy0cLcinJxwF//W1biZMt6dF0g==
X-Received: by 2002:a17:907:b9c3:b0:9f3:18f8:475b with SMTP id xa3-20020a170907b9c300b009f318f8475bmr6952555ejc.62.1700209828011;
        Fri, 17 Nov 2023 00:30:28 -0800 (PST)
Received: from sgarzare-redhat (host-79-46-200-199.retail.telecomitalia.it. [79.46.200.199])
        by smtp.gmail.com with ESMTPSA id q2-20020a170906b28200b009ad8acac02asm538543ejz.172.2023.11.17.00.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Nov 2023 00:30:27 -0800 (PST)
Date: Fri, 17 Nov 2023 09:30:19 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [RFC PATCH v1 2/2] vsock/test: SO_RCVLOWAT + deferred credit
 update test
Message-ID: <tbvwohgvrc6kvlsyap3sk5zqww5q6schsu4szx7e23wgg7pvb3@e7xa5mg5inul>
References: <20231108072004.1045669-1-avkrasnov@salutedevices.com>
 <20231108072004.1045669-3-avkrasnov@salutedevices.com>
 <zukasb6k7ogta33c2wik6cgadg2rkacestat7pkexd45u53swh@ovso3hafta77>
 <923a6149-3bd5-c5b4-766d-8301f9e7484a@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <923a6149-3bd5-c5b4-766d-8301f9e7484a@salutedevices.com>

On Fri, Nov 17, 2023 at 10:12:38AM +0300, Arseniy Krasnov wrote:
>
>
>On 15.11.2023 14:11, Stefano Garzarella wrote:
>> On Wed, Nov 08, 2023 at 10:20:04AM +0300, Arseniy Krasnov wrote:
>>> This adds test which checks, that updating SO_RCVLOWAT value also sends
>>
>> You can avoid "This adds", and write just "Add test ...".
>>
>> See https://docs.kernel.org/process/submitting-patches.html#describe-your-changes
>>
>>     Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
>>     instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
>>     to do frotz", as if you are giving orders to the codebase to change
>>     its behaviour.
>>
>> Also in the other patch.
>>
>>> credit update message. Otherwise mutual hungup may happen when receiver
>>> didn't send credit update and then calls 'poll()' with non default
>>> SO_RCVLOWAT value (e.g. waiting enough bytes to read), while sender
>>> waits for free space at receiver's side.
>>>
>>> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>>> ---
>>> tools/testing/vsock/vsock_test.c | 131 +++++++++++++++++++++++++++++++
>>> 1 file changed, 131 insertions(+)
>>>
>>> diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
>>> index c1f7bc9abd22..c71b3875fd16 100644
>>> --- a/tools/testing/vsock/vsock_test.c
>>> +++ b/tools/testing/vsock/vsock_test.c
>>> @@ -1180,6 +1180,132 @@ static void test_stream_shutrd_server(const struct test_opts *opts)
>>>     close(fd);
>>> }
>>>
>>> +#define RCVLOWAT_CREDIT_UPD_BUF_SIZE    (1024 * 128)
>>> +#define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE    (1024 * 64)
>>
>> What about adding a comment like the one in the cover letter about
>> dependency with kernel values?
>>
>> Please add it also in the commit description.
>>
>> I'm thinking if we should move all the defines that depends on the
>> kernel in some special header.
>
>IIUC it will be new header file in tools/testing/vsock, which includes such defines. At
>this moment in will contain only VIRTIO_VSOCK_MAX_PKT_BUF_SIZE. Idea is that such defines

So this only works on the virtio transport though, not the other
transports, right? (but maybe the others don't have this problem, so
it's fine).

>are not supposed to use by user (so do not move it to uapi headers), but needed by tests
>to check kernel behaviour. Please correct me if i'm wrong.

Right!
Maybe if it's just one, we can leave it there for now, but with a
comment on top explaining where it comes.

Thanks,
Stefano


