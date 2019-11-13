Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 073CFFB4A6
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKMQHk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 11:07:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48903 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726074AbfKMQHk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 11:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573661259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cF5BCoLqyGRO1rCf8d3eLxqrQOyJ+ynaDWusqjCl5ic=;
        b=ZTV2zyRG72PYWWRqu9UuA/rMxEnurlq3yZR+nI3gGCLlEtUNN9EPDdPfvSKGrw75uq50ys
        3acgjY0U9faOUQLhsBgV4r7JUfnHAYrBPAWyRDF8vyBB67/HUITQtwewF8l1Cv7PtsBows
        BfjncJcsyNw00IRFlr53W9XJfGPVutY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-GHAmq15PMy29uLGjn8FuHA-1; Wed, 13 Nov 2019 11:07:38 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E63AB108FAF1;
        Wed, 13 Nov 2019 16:07:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-183.ams2.redhat.com [10.36.116.183])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06EE25F900;
        Wed, 13 Nov 2019 16:07:31 +0000 (UTC)
Subject: Re: [kvm-unit-test PATCH 3/5] travis.yml: Test with KVM instead of
 TCG (on x86)
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>
References: <20191113112649.14322-1-thuth@redhat.com>
 <20191113112649.14322-4-thuth@redhat.com> <87sgmr7uoy.fsf@linaro.org>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <e7246b2d-e76a-1302-513b-30cbfacdd4c6@redhat.com>
Date:   Wed, 13 Nov 2019 17:07:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <87sgmr7uoy.fsf@linaro.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: GHAmq15PMy29uLGjn8FuHA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/11/2019 14.49, Alex Benn=C3=A9e wrote:
>=20
> Thomas Huth <thuth@redhat.com> writes:
>=20
>> Travis nowadays supports KVM in their CI pipelines, so we can finally
>> run the kvm-unit-tests with KVM instead of TCG here. Unfortunately, ther=
e
>> are some quirks: First, the QEMU binary has to be running as root, other=
wise
>> you get an "permission denied" error here - even if you fix up the acces=
s
>> permissions to /dev/kvm first.
>=20
> Could it be another resource it's trying to access?

I did some more tests with strace and some "ls -l /dev/kvm" spread
around the scripts, and it seems like the permissions get reset on
Debian when a process tries to open /dev/kvm ? I.e. after doing a
"chmod", I correctly see:

crw-rw-rw- 1 root kvm 10, 232 Nov 13 15:03 /dev/kvm

... but after the run script tried to launch qemu, it's back to:

crw-rw---- 1 root kvm 10, 232 Nov 13 15:03 /dev/kvm

I assume some udev magic is enforcing this?

So it's as Paolo said in his mail, you need to be root or in the kvm
group to be able to use KVM on Debian / Ubuntu. Unfortunately a simple
"usermod -a -G kvm $USER" also does not seem to work here, since you
need a new login shell to take the change into account ... well, I could
then run the run_test.sh script through "sudo -E su $USER -c ..." [1]
but that's ugly too.

But instead of doing "chmod u+s ...", this seems to be working, too:

  sudo chgrp kvm /usr/bin/qemu-system-*
  sudo chmod g+s /usr/bin/qemu-system-*

... which sounds like the least ugliest hack to me currently, so I think
I'll go with that version.

 Thomas


[1] That's also what Travis suggests here:
    https://docs.travis-ci.com/user/reference/trusty/#group-membership

