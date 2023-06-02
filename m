Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1C272095B
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236889AbjFBSqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 14:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbjFBSq2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 14:46:28 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF8E1AB
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 11:46:26 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-97467e06511so127822166b.2
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 11:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685731585; x=1688323585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcMbFM1KZ0fWjQ5u5YqOge5c5db55RI/e4TXcTuJU+4=;
        b=m26h9HJl4/Hi+sQUV3crL1mH8JT1NXlbnXTT27FM2w9akWJfgCkELak9VpHuAMc0Uo
         9j2xEPsXNCwTn8BPX5xNvGt63qtniCft0QGZDSycYW9KQoIloKAQKjHo/liqkccjpOuN
         oh+qR6o1vrxQRfccVhn6yDCXZUz9s+vXzYrnKT5Y4HphLNOEBssB1qDYfdVhnmNx4s6W
         XFOtmz3zIzVSeVKg1TOJXsYrhbc2M5pVG2OxxeCkCy//3Opomwj65Knd3O38znyCWnIA
         eowJ4juq2QUH7PJehtAR128z8cpqPl4gRPBBPRcU3eNxxZV7TmoF6CKC7hLmMzEygX8s
         EC8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685731585; x=1688323585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gcMbFM1KZ0fWjQ5u5YqOge5c5db55RI/e4TXcTuJU+4=;
        b=Meljxxq2Dwlt9GOYmTt6+NaDorwBRlr/UDTGBs4McHwmnny2j+sHHjlPW1nGHi/iYG
         g2I7jvT31yZMGMFtbnE0/P0RchWtei1uXYGSJaEdEeX+cXyJGKRXmwbJOt/J0thljVVe
         hO9PjyDCiC+sHcMRLKVOE2kxQDFzb2mDdEj0Wu3L7XNw/pcrd2gBazrVP8WCGg+Ih3ab
         +NtKdYwf6RYlPsnp5ZEywVqZr4vFYi7M/swQfFPMSuRDSMzZWjV6Bd3tiEwzYVeT9R49
         cID1MXDbQlz5t2e7G+oVHoMCQe79wri6rlYU7wHndA5cgnkQKXjE0XLmn/IEiBLI7csD
         haNQ==
X-Gm-Message-State: AC+VfDzqIndG8DsKM77WaNp9AcVrpA6tXFCGOJKK2cqmnQY9tjzl6hX1
        0v7lYCJwPBfHnkDiNQdCfXGSAlc+5MmktDp0qgQ=
X-Google-Smtp-Source: ACHHUZ5URTJBxPBlyNic36Y6ggfMsax6eUizwkvnxwoIykktv5r48r1z3B0jUMTPKz/8GC4Zbsi11eHb9B+CDk+3xRg=
X-Received: by 2002:a17:906:6a0c:b0:973:daa0:2f6 with SMTP id
 qw12-20020a1709066a0c00b00973daa002f6mr12535244ejc.3.1685731584596; Fri, 02
 Jun 2023 11:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230515160506.1776883-1-stefanha@redhat.com> <20230515160506.1776883-3-stefanha@redhat.com>
 <8b0ced3c-2fb5-2479-fe78-f4956ac037a6@linux.ibm.com> <CAAAx-8Km7J8dfz_63y1W5wE8MH7hJXo04ajY1A-ctv--x9CpGA@mail.gmail.com>
 <638895f7-78b8-6e15-bbf8-916fc1513287@linux.ibm.com>
In-Reply-To: <638895f7-78b8-6e15-bbf8-916fc1513287@linux.ibm.com>
From:   Sam Li <faithilikerun@gmail.com>
Date:   Sat, 3 Jun 2023 02:45:58 +0800
Message-ID: <CAAAx-8LvRc73G0q30VZW8EFdZE_WNiPkWwgMxAmaLdJ-o_v2bw@mail.gmail.com>
Subject: Re: [PULL v2 02/16] block/file-posix: introduce helper functions for
 sysfs attributes
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>, qemu-devel@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Kevin Wolf <kwolf@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-block@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>,
        Hanna Reitz <hreitz@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Fam Zheng <fam@euphon.net>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Matthew Rosato <mjrosato@linux.ibm.com> =E4=BA=8E2023=E5=B9=B46=E6=9C=883=
=E6=97=A5=E5=91=A8=E5=85=AD 02:41=E5=86=99=E9=81=93=EF=BC=9A
>
> On 6/2/23 2:18 PM, Sam Li wrote:
> > Matthew Rosato <mjrosato@linux.ibm.com> =E4=BA=8E2023=E5=B9=B46=E6=9C=
=881=E6=97=A5=E5=91=A8=E5=9B=9B 02:21=E5=86=99=E9=81=93=EF=BC=9A
> >>
> >> On 5/15/23 12:04 PM, Stefan Hajnoczi wrote:
> >>> From: Sam Li <faithilikerun@gmail.com>
> >>>
> >>> Use get_sysfs_str_val() to get the string value of device
> >>> zoned model. Then get_sysfs_zoned_model() can convert it to
> >>> BlockZoneModel type of QEMU.
> >>>
> >>> Use get_sysfs_long_val() to get the long value of zoned device
> >>> information.
> >>
> >> Hi Stefan, Sam,
> >>
> >> I am having an issue on s390x using virtio-blk-{pci,ccw} backed by an =
NVMe partition, and I've bisected the root cause to this commit.
> >>
> >> I noticed that tests which use the partition e.g. /dev/nvme0n1p1 as a =
backing device would fail, but those that use the namespace e.g. /dev/nvme0=
n1 would still succeed.  The root issue appears to be that the block device=
 associated with the partition does not have a "max_segments" attribute, an=
d prior to this patch hdev_get_max_segment() would return -ENOENT in this c=
ase.  After this patch, however, QEMU is instead crashing.  It looks like g=
_file_get_contents is returning 0 with a len =3D=3D 0 if the specified sysf=
s path does not exist.  The following diff on top seems to resolve the issu=
e for me:
> >>
> >>
> >> diff --git a/block/file-posix.c b/block/file-posix.c
> >> index 0ab158efba2..eeb0247c74e 100644
> >> --- a/block/file-posix.c
> >> +++ b/block/file-posix.c
> >> @@ -1243,7 +1243,7 @@ static int get_sysfs_str_val(struct stat *st, co=
nst char *attribute,
> >>                                  major(st->st_rdev), minor(st->st_rdev=
),
> >>                                  attribute);
> >>      ret =3D g_file_get_contents(sysfspath, val, &len, NULL);
> >> -    if (ret =3D=3D -1) {
> >> +    if (ret =3D=3D -1 || len =3D=3D 0) {
> >>          return -ENOENT;
> >>      }
> >>
> >
> > Hi Matthew,
> >
> > Thanks for the information. After some checking, I think the bug here
> > is that g_file_get_contens returns g_boolean value and the error case
> > will return 0 instead of -1 in my previous code. Can the following
> > line fix your issue on the s390x device?
> >
> > + if (ret =3D=3D FALSE) {
> >
> > https://docs.gtk.org/glib/func.file_get_contents.html
>
> Hi Sam,
>
> Ah, good point, I didn't notice file_get_contents was meant to be a bool =
return and wondered why I was getting a return of 0 in the failing case, he=
nce the check for len =3D=3D 0.
>
> Anyway, yes, I verified that checking for ret =3D=3D FALSE fixes the issu=
e.  FWIW, along the same line I also checked that this works:
>
>     if (!g_file_get_contents(sysfspath, val, &len, NULL)) {
>         return -ENOENT;
>     }
>
> which I personally think looks cleaner and matches the other uses of g_fi=
le_get_contents in QEMU.  Could also get rid of ret and just return 0 at th=
e bottom of the function.

Indeed. I will fix this. Thanks!

Sam
