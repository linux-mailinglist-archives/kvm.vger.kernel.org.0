Return-Path: <kvm+bounces-42114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9ACA72EC6
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 12:21:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D720D3BA0E2
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 11:21:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78717212B0D;
	Thu, 27 Mar 2025 11:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NFh764ZF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A49020E6F1
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 11:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743074472; cv=none; b=o/J8+x0BYVHmbcYWArzm6AqSto/95OizpexTGOm1o8Fe1zwubFq7bVk/lnmNGCehpyGYfYDx27u9rEgP15j1Cpji/SyG66uqVHoSoT3iMtdjFFkEAWRFngIGhEmiskzzf47SnYqmesO/dUGNELs9m5tzJmCq4x2ej1FbkKO9NR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743074472; c=relaxed/simple;
	bh=3ZrnUp9Fhn9UaUnyyfKY5MriRafswzCPAWMuIe6cdA8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=edOe8MYq/0pKEyPK6GHI/r/VSOSoauUaRObXbZnRT6dkyo6FN+EM4rUE8QotQ9RxtnBeX8KYTx6T6NNzLUTW1a+MabEQzHQ4wrACfr7cdUwhCzCY4LRueHwaJQBHEb4ZYAi8PpRvlJylooMSYTKqM/LyVMQAhcGl3LFfx5RxF94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NFh764ZF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743074469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JRX5KdSGkfJSEr/WHGFbdRRh0ujs8cABCCjOijR+WkE=;
	b=NFh764ZFdErs494Ki2p584NvZ/BdLf5aC/c+wRyZTTcU+iqrmRp0QvcH09YWZgfi5TrxQp
	46dbtcSxbK7Ps9o21Kutu/H3muquIfTNPn24eYcjx7juTyb1CcAfHFkeOJFk+btyzOtnen
	jN3TiQrzRsdCE4YMqdu5tOpGmSw/XNw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-C29qqi5tP8uCOZfhrSGhNQ-1; Thu, 27 Mar 2025 07:21:08 -0400
X-MC-Unique: C29qqi5tP8uCOZfhrSGhNQ-1
X-Mimecast-MFC-AGG-ID: C29qqi5tP8uCOZfhrSGhNQ_1743074468
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-39142ce2151so397906f8f.1
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 04:21:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743074467; x=1743679267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JRX5KdSGkfJSEr/WHGFbdRRh0ujs8cABCCjOijR+WkE=;
        b=HCylJHtDKa0qQQkJALWR4GsA/XmWLM67V6ULzHO6yiNo0Zzy5EW8md6hqZblqH2ZMb
         H97CczDyZFwYPOshzF8WXlZ5QQ+ycTiWpiZALmOG6hw5LZ3UtYYcZtjtkHx0eVgOhTNj
         UsKgzNG9WMfuANy9Og4h2jVAxnkK4FJS2+f/G7VPqtdwbCRFDkU1dHhTKIKhJu56AIjJ
         UqMRpZomwJsrZmotiFerCQK7R8KnUNaH7MHSwhEaTWgA+Sr8Z6mh/RlWCjKVuIB4Ea/2
         Q4I9M0uAIwBX+3sl340HYu4qjhOTXB4a0Q2aHGsmbwy0K9PUoicSQPSEIW0SpMzGy9mP
         JfyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnGbWGdVSZaoWed/83gBJLn9lZ+WW+MEiA4NrRwBEQzj+P7qbv1tAEFAh4nGnHhOnu0Ic=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUl5bNnZhJF8gsObwsiE+MOcs84EyrVmqoSnCBgoUxUyn9g68k
	40+UharAgJk+SMELnJOB5OT23wultT37KL2FqgIHnUz2BFrzsWSXmzv3cNeTYvOTwQvkWzJEJ+d
	JkH40JmKNlBxS2F5u2TE8EHu51+lg7SoFP9Kc7X5JcIi/x6a77g==
X-Gm-Gg: ASbGncshYPGE2ymRpcKJHu0GJ+bo83KS00yVRuAGk93OTQAPbwERZ+eKBnjqU2JR/mW
	J6lmudF8FzH4p+9M5WLMKeqWfBAUaqMWGMr3h5PsBl36OCvH5GzJyBHYSRk7LQlXZQlw4CfmNx6
	Z/9FcDaNOGlHS+Gn7Gzv2RDYZU7GhnStnrA1L7kcwJCV1VM70vJ6i2XBwFwoj3m3YH7c3TuYmWK
	OEZkihOBhtTr7lSAWuo4TiHvPC4KEjMftPOul072FOhujMEvgb1qb4NpfApBeEXyPRXn9/Y+shw
	6Yns7r2q1rhNgcL0E5W74nkR9tW2FB9y3ByETyW3n57TjlNupxoVRdElQ9wRuAEM
X-Received: by 2002:a05:6000:2d82:b0:390:e158:a1b8 with SMTP id ffacd0b85a97d-39ad1787adfmr2287621f8f.43.1743074467493;
        Thu, 27 Mar 2025 04:21:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG2h7ayPlB4Kss3y5VeCbbDdjXM4BImGSUtzVmo6fk6xKoLcS1gfkg1jwqkOYe+guaCoI3pLg==
X-Received: by 2002:a05:6000:2d82:b0:390:e158:a1b8 with SMTP id ffacd0b85a97d-39ad1787adfmr2287591f8f.43.1743074467014;
        Thu, 27 Mar 2025 04:21:07 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-55.business.telecomitalia.it. [87.12.25.55])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39ac80e6814sm8150600f8f.56.2025.03.27.04.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Mar 2025 04:21:06 -0700 (PDT)
Date: Thu, 27 Mar 2025 12:21:02 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, syzbot <syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com>, 
	eperezma@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	virtualization@lists.linux.dev, oleg@redhat.com, ebiederm@xmission.com, stefanha@redhat.com, 
	brauner@kernel.org
Subject: Re: [syzbot] [kvm?] [net?] [virt?] INFO: task hung in
 __vhost_worker_flush
Message-ID: <fd77ljndgwznty4e45t7o55sbyfdlxfl7otly5ib7mjlnsxcwb@ve45z34reswm>
References: <Zr-VGSRrn0PDafoF@google.com>
 <000000000000fd6343061fd0d012@google.com>
 <Zr-WGJtLd3eAJTTW@google.com>
 <20240816141505-mutt-send-email-mst@kernel.org>
 <02862261-b7cf-44c1-8437-5e128cfd1201@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <02862261-b7cf-44c1-8437-5e128cfd1201@oracle.com>

On Mon, Aug 19, 2024 at 10:19:44AM -0500, Mike Christie wrote:
>On 8/16/24 1:17 PM, Michael S. Tsirkin wrote:
>> On Fri, Aug 16, 2024 at 11:10:32AM -0700, Sean Christopherson wrote:
>>> On Fri, Aug 16, 2024, syzbot wrote:
>>>>> On Wed, May 29, 2024, syzbot wrote:
>>>>>> Hello,
>>>>>>
>>>>>> syzbot found the following issue on:
>>>>>>
>>>>>> HEAD commit:    9b62e02e6336 Merge tag 'mm-hotfixes-stable-2024-05-25-09-1..
>>>>>> git tree:       upstream
>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16cb0eec980000
>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3e73beba72b96506
>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990
>>>>>> compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
>>>>>>
>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>
>>>>>> Downloadable assets:
>>>>>> disk image: https://storage.googleapis.com/syzbot-assets/61b507f6e56c/disk-9b62e02e.raw.xz
>>>>>> vmlinux: https://storage.googleapis.com/syzbot-assets/6991f1313243/vmlinux-9b62e02e.xz
>>>>>> kernel image: https://storage.googleapis.com/syzbot-assets/65f88b96d046/bzImage-9b62e02e.xz
>>>>>>
>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>> Reported-by: syzbot+7f3bbe59e8dd2328a990@syzkaller.appspotmail.com
>>>>>
>>>>> #syz unset kvm
>>>>
>>>> The following labels did not exist: kvm
>>>
>>> Hrm, looks like there's no unset for a single subsytem, so:
>>>
>>> #syz set subsystems: net,virt
>>
>> Must be this patchset:
>>
>> https://lore.kernel.org/all/20240316004707.45557-1-michael.christie@oracle.com/
>>
>> but I don't see anything obvious there to trigger it, and it's not
>> reproducible yet...
>>
>
>Sorry, I missed the original post from May.
>
>I'm trying to replicate it now, but am not seeing it.
>
>The only time I've seen something similar is when the flush is actually waiting
>for a work item to complete, but I don't think the sysbot tests that for vsock.
>So, I think I'm hitting a race that I'm just not seeing yet. I'm just getting
>back from vacation, and will do some more testing/review this week.

Hi Mike,
looking at the syzbot virt monthly report I saw this issuse still open 
and with crashes:

   https://syzkaller.appspot.com/bug?extid=7f3bbe59e8dd2328a990

Have you had a chance to take a look?

Thanks,
Stefano


