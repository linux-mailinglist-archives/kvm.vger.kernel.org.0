Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4B87D2EB7
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 11:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjJWJni (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 05:43:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjJWJng (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 05:43:36 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5619E99
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 02:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=QJnLNJLIKQ/1yQL84M0rKohbw6CIp8aEbajAdE1XPdk=; b=CUdLWyALBJqmFbDGesKzP61pFX
        yMyqMvl8eVP0caNQqIuXFssX8lBUzWgpK0Cz1fE8ycmQ7Zc364gqWYFOTEzYFjujFruaRGkPf/g16
        2GvuZQFH7+oO5B5p06BuB9jm6y2Zb0P3hOi7BsVk8I5q9ZzHdu8NlWI5fNR9PAEQX1FoAvUwcQygR
        BrsvhK9U4XPB2XlRKtxIRyatSt0Ur8ot4pBTYRH2JCADNdaRtv6ro02JzxVUyyL4XCxYYdUYirxQk
        sSvo6tPiHXwM1MjlSxzPFY4mccQVObrvA0FIliR8oJ5LExfja1ipELp+yx7XX+ndJ15ku4AvAk9s8
        aSwfOOyQ==;
Received: from [31.94.4.150] (helo=[IPv6:::1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qurSo-00D2s3-IS; Mon, 23 Oct 2023 09:43:10 +0000
Date:   Mon, 23 Oct 2023 10:42:58 +0100
From:   David Woodhouse <dwmw2@infradead.org>
To:     Igor Mammedov <imammedo@redhat.com>
CC:     qemu-devel@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Paul Durrant <paul@xen.org>,
        =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_11/12=5D_hw/xen=3A_automaticall?= =?US-ASCII?Q?y_assign_device_index_to_block_devices?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231023113002.0e83c209@imammedo.users.ipa.redhat.com>
References: <20231016151909.22133-1-dwmw2@infradead.org> <20231016151909.22133-12-dwmw2@infradead.org> <20231018093239.3d525fd8@imammedo.users.ipa.redhat.com> <3f3487af227dcdce7afb37e8406d5ce8dcdbf55f.camel@infradead.org> <20231023113002.0e83c209@imammedo.users.ipa.redhat.com>
Message-ID: <8CBFDABE-6BD7-4924-BB69-EF5EAA04A34D@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23 October 2023 10:30:02 BST, Igor Mammedov <imammedo@redhat=2Ecom> wro=
te:
>On Wed, 18 Oct 2023 09:32:47 +0100
>David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>
>> On Wed, 2023-10-18 at 09:32 +0200, Igor Mammedov wrote:
>> > On Mon, 16 Oct 2023 16:19:08 +0100
>> > David Woodhouse <dwmw2@infradead=2Eorg> wrote:
>> >  =20
>> > > From: David Woodhouse <dwmw@amazon=2Eco=2Euk>
>> > >  =20
>> >=20
>> > is this index a user (guest) visible? =20
>>=20
>> Yes=2E It defines what block device (e=2Eg=2E /dev/xvda) the disk appea=
rs as
>> in the guest=2E In the common case, it literally encodes the Linux
>> major/minor numbers=2E So xvda (major 202) is 0xca00, xvdb is 0xca10 et=
c=2E
>
>that makes 'index' an implicit ABI and a subject to versioning
>when the way it's assigned changes (i=2Ee=2E one has to use versioned
>machine types to keep older versions working the they used to)=2E
>
>From what I remember it's discouraged to make QEMU invent
>various IDs that are part of ABI (guest or mgmt side)=2E
>Instead it's preferred for mgmt side/user to provide that explicitly=2E
>
>Basically you are trading off manageability/simplicity at QEMU
>level with CLI usability for human user=2E
>I don't care much as long as it is hidden within xen code base,
>but maybe libvirt does=2E

Well, it can still be set explicitly=2E So not so much a "trade-off" as ad=
ding the option for the user to choose the simple way=2E

Yes, in a way it's an ABI, just like the dynamic assignment of PCI devfn f=
or network devices added with "-nic"=2E And I think also for virtio block d=
evices too? And for the ISA ne2000=2E

But it seems unlikely that we'll ever really want to change "the first one=
 is xvda, the second is xvdb=2E=2E=2E=2E"
