Return-Path: <kvm+bounces-3690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E5D806FDD
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 13:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1A741C20BA2
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 12:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3551A364C7;
	Wed,  6 Dec 2023 12:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JQUjDZ6x"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 946BD135
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 04:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701866209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+wWTErr4+br/lS77xstExEId531sIBb8lR0RHgVRhdw=;
	b=JQUjDZ6xTV+ibSOSlp2+HgXsIfqyVRkSlikrG2sadrAAWNdyy0FjhvDOy/3osKyPdh0VKL
	OoteY+AipPv7rvkQ2Sjj8hCuA7SGNQ2hAYKO7aCL8Jdv1vpI76yqeu98HiA0Ng0LC6A5C2
	Y7KzEotrixphocxW8ndfSthyzVQivTQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-300-7pSqiMlkPDqVtEmBBOhnBA-1; Wed, 06 Dec 2023 07:36:46 -0500
X-MC-Unique: 7pSqiMlkPDqVtEmBBOhnBA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33342e25313so662810f8f.3
        for <kvm@vger.kernel.org>; Wed, 06 Dec 2023 04:36:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701866205; x=1702471005;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+wWTErr4+br/lS77xstExEId531sIBb8lR0RHgVRhdw=;
        b=P+by2lbbw35WOKKg7bU0Qon2EiofUdgR/T9pbANAOR7Ob7yeUwhpnfu5XO+SLy6DPF
         UcPYJIz1Cs8hcO790br8fLm/seV6UCNM5nBPbgAX2Y290Ue2M13O8MD35N0oq+of3gRW
         RhNzQsT1ZJPy9lTYrUtwkhaJ2dudkYpmZuAYzMMsxDnsdXu6m6ZGMqJa4XQM4XFhlxcg
         kuw090M2bQCGBYb8QAaYNdJISrpTLF/dleX4ajnoGIET0dZW0sGFAv62/yriNRWYHt4X
         lHoflOOv3qunyqLqpCrNXMltxcQvdK50ohh7otkm7kWMM6Sc4LfvPIg71hXjjTqLj4if
         uDnw==
X-Gm-Message-State: AOJu0YxcwuezktlGIoJQA+DiZhGPEXQYt1vdaTvB2ZVRRNFviIajLK9/
	NwyQxCW7JnaIk4VSTdwseAd9/uUhRaFUYIFFJk8YvDuGncai42YozqZGyfoYa7Z6arobP7sPfQ4
	PHr9aQcsPipaY
X-Received: by 2002:a05:600c:54c4:b0:40b:5e59:c566 with SMTP id iw4-20020a05600c54c400b0040b5e59c566mr576839wmb.144.1701866205435;
        Wed, 06 Dec 2023 04:36:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH/vEGZCJkYxH9m/asg6eOY10xJd724rHM6KqP77CdEjZ+725bWvQSDJ2vM9F7BQVO2ePLQTw==
X-Received: by 2002:a05:600c:54c4:b0:40b:5e59:c566 with SMTP id iw4-20020a05600c54c400b0040b5e59c566mr576828wmb.144.1701866205110;
        Wed, 06 Dec 2023 04:36:45 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id z19-20020a05600c0a1300b0040596352951sm1259464wmp.5.2023.12.06.04.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 04:36:44 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Sean
 Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH v2 12/16] KVM: x86: Make Hyper-V emulation optional
In-Reply-To: <46235.123120606372000354@us-mta-490.us.mimecast.lan>
References: <20231205103630.1391318-1-vkuznets@redhat.com>
 <20231205103630.1391318-13-vkuznets@redhat.com>
 <46235.123120606372000354@us-mta-490.us.mimecast.lan>
Date: Wed, 06 Dec 2023 13:36:43 +0100
Message-ID: <878r67mrs4.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Jeremi Piotrowski <jpiotrowski@linux.microsoft.com> writes:

> On Tue, Dec 05, 2023 at 11:36:26AM +0100, Vitaly Kuznetsov wrote:
>> Hyper-V emulation in KVM is a fairly big chunk and in some cases it may be
>> desirable to not compile it in to reduce module sizes as well as the attack
>> surface. Introduce CONFIG_KVM_HYPERV option to make it possible.
>> 
>> Note, there's room for further nVMX/nSVM code optimizations when
>> !CONFIG_KVM_HYPERV, this will be done in follow-up patches.
>> 
>> Reorganize Makefile a bit so all CONFIG_HYPERV and CONFIG_KVM_HYPERV files
>> are grouped together.
>> 
>
> Wanted to test this for the case where KVM is running as a nested hypervisor on
> Hyper-V but it doesn't apply cleanly - what base did you use? Tried v6.6,
> v6.7-rc1, and v6.7-rc4.

Hi Jeremi,

the base was 'kvm/next' (git://git.kernel.org/pub/scm/virt/kvm/kvm.git,
'next' branch):

commit e9e60c82fe391d04db55a91c733df4a017c28b2f (kvm/next)
Author: Paolo Bonzini <pbonzini@redhat.com>
Date:   Tue Nov 21 11:24:08 2023 -0500

    selftests/kvm: fix compilation on non-x86_64 platforms

-- 
Vitaly


