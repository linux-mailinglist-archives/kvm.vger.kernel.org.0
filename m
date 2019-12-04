Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69655112EE7
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 16:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbfLDPrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 10:47:39 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55428 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727878AbfLDPri (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 10:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575474457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZeT4eCJP83I9XOzpzs9v7jQ3UQn1BfRckosLr2Q8ki4=;
        b=DvmVH+sgaNjLMyqsZ5FsaE+TqegTDiIj/jIeEzUYj0j1GxCuqmzJXP3kDh0YBuGsl9KEpD
        kvx3yJWqP3HG4v7psaJ6QgxzSd+tV8e3ypcPrU4KzE6nv8DigcQ8BHjd0Plruj2CSP1cZx
        0MVangFrRPyOx6GJLox2NlLrO9ERxpM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-JB1bfsHhNOOrCVhyzWEiiw-1; Wed, 04 Dec 2019 10:47:33 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0C0F12A7E49;
        Wed,  4 Dec 2019 15:47:32 +0000 (UTC)
Received: from localhost (ovpn-116-90.gru2.redhat.com [10.97.116.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32561A4B60;
        Wed,  4 Dec 2019 15:47:31 +0000 (UTC)
Date:   Wed, 4 Dec 2019 12:47:30 -0300
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Catherine Ho <catherine.hecx@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org
Subject: Re: [PATCH] target/i386: relax assert when old host kernels don't
 include msrs
Message-ID: <20191204154730.GB498046@habkost.net>
References: <1575449430-23366-1-git-send-email-catherine.hecx@gmail.com>
 <2ac1a83c-6958-1b49-295f-92149749fa7c@redhat.com>
 <CAEn6zmFex9WJ9jr5-0br7YzQZ=jA5bQn314OM+U=Q6ZGPiCRAg@mail.gmail.com>
 <714a0a86-4301-e756-654f-7765d4eb73db@redhat.com>
 <CAEn6zmHnTLZxa6Qv=8oDUPYpRD=rvGxJOLjd8Qb15k9-3U+CKw@mail.gmail.com>
 <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
MIME-Version: 1.0
In-Reply-To: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: JB1bfsHhNOOrCVhyzWEiiw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 04, 2019 at 04:34:45PM +0100, Paolo Bonzini wrote:
> On 04/12/19 16:07, Catherine Ho wrote:
> >> Ok, so the problem is that some MSR didn't exist in that version.  Whi=
ch
> > I thought in my platform, the only MSR didn't exist is MSR_IA32_VMX_BAS=
IC
> > (0x480). If I remove this kvm_msr_entry_add(), everything is ok, the gu=
est can
> > be boot up successfully.
> >=20
>=20
> MSR_IA32_VMX_BASIC was added in kvm-4.10.  Maybe the issue is the
> _value_ that is being written to the VM is not valid?  Can you check
> what's happening in vmx_restore_vmx_basic?

I believe env->features[FEAT_VMX_BASIC] will be initialized to 0
if the host kernel doesn't have KVM_CAP_GET_MSR_FEATURES.

--=20
Eduardo

