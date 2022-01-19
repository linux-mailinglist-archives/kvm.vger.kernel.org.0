Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8BF4939BB
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 12:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354256AbiASLlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 06:41:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44655 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236274AbiASLlB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Jan 2022 06:41:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642592455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FmMUtwULPN23DvBwyj9A3TEyqM30MbuwdE8vFcNpedo=;
        b=fsr/Pq15vwFy95PMbEHKMJk2EmCyenK2996S/p3vZSPaN/7VoC1FLHo8Sdb2qFFPD44HHz
        5ZoCEQm5e+0ndwh2vWT1S26PiSnmYOKUngyLpW13rOwdJr+VWQ9vBJzth9gHAGksgcDEv/
        /lPS4js2TQRY/4pUaaVWhC9CpG9lbo0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-EYdCWlqQMYKzKVthj5jqDg-1; Wed, 19 Jan 2022 06:40:52 -0500
X-MC-Unique: EYdCWlqQMYKzKVthj5jqDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2EAC41091DA1;
        Wed, 19 Jan 2022 11:40:51 +0000 (UTC)
Received: from localhost (unknown [10.39.194.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B3461059584;
        Wed, 19 Jan 2022 11:40:45 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC] vfio: Revise and update the migration uAPI description
In-Reply-To: <20220118210048.GG84788@nvidia.com>
Organization: Red Hat GmbH
References: <0-v1-a4f7cab64938+3f-vfio_mig_states_jgg@nvidia.com>
 <20220118125522.6c6bb1bb.alex.williamson@redhat.com>
 <20220118210048.GG84788@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 19 Jan 2022 12:40:43 +0100
Message-ID: <87sftkc5s4.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 18 2022, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Tue, Jan 18, 2022 at 12:55:22PM -0700, Alex Williamson wrote:
>> At some point later hns support is ready, it supports the migration
>> region, but migration fails with all existing userspace written to the
>> below spec.  I can't imagine that a device advertising migration, but it
>> being essentially guaranteed to fail is a viable condition and we can't
>> retroactively add this proposed ioctl to existing userspace binaries.
>> I think our recourse here would be to rev the migration sub-type again
>> so that userspace that doesn't know about devices that lack P2P won't
>> enable migration support.
>
> Global versions are rarely a good idea. What happens if we have three
> optional things, what do you set the version to in order to get
> maximum compatibility?
>
> For the scenario you describe it is much better for qemu to call
> VFIO_DEVICE_MIG_ARC_SUPPORTED on every single transition it intends to
> use when it first opens the device. If any fail then it can deem the
> device as having some future ABI and refuse to use it with migration.

Userspace having to discover piecemeal what is and what isn't supported
does not sound like a very good idea. It should be able to figure that
out in one go.

>
>> So I think this ends up being a poor example of how to extend the uAPI.
>> An opt-out for part of the base specification is hard, it's much easier
>> to opt-in P2P as a feature.
>
> I'm not sure I understand this 'base specification'. 
>
> My remark was how we took current qemu as an ABI added P2P to the
> specification and defined it in a way that is naturally backwards
> compatible and is still well specified.

I agree with Alex that this approach, while clever, is not a good way to
extend the uapi.

What about leaving the existing migration region alone (in order to not
break whatever exists out there) and add a v2 migration region that
defines a base specification (the mandatory part that everyone must
support) and a capability mechanism to allow for extensions like P2P?
The base specification should really only contain what everybody can and
will need to implement; if we know that mlx5 will need more, we simply
need to define those additional features right from the start.

(I do not object to using a FSM for describing the state transitions; I
have not reviewed it so far.)

