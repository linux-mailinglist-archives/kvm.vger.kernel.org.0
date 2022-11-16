Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC0662C471
	for <lists+kvm@lfdr.de>; Wed, 16 Nov 2022 17:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbiKPQaz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 11:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239012AbiKPQ30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 11:29:26 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5203325C58
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:23:37 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id t10so22501431ljj.0
        for <kvm@vger.kernel.org>; Wed, 16 Nov 2022 08:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fBCjRdO6ZUYfFXcJUJ16vqsWOlK8LDenzaLFInuWfog=;
        b=iOnSbYG/jKOspLdgUJs9ASIAU+1KQG8uXWsN2jZJw5yeTcVrRqAx7fpuEy2k4UG7qs
         WkuRbt81BsWWFh/Lb2sJK5LKF1fmEanGC3VPya8dKDowjnUk1VPdoKWJaz3UL+9hU7zz
         BFRhhZk00ipPZdHjTn+xd7s/PASQkNDP0mKnNj5xwbbpcBCH2jBUtubX6i67c2E7Dxct
         0AYZAIRC1fXYAYTtOAso99y256kfwRZYkkD+HJGneBXtKyzLdnLplnUbe3yTDBfymkh+
         eIECmFeeqlbDjANmx3YJpaTWjbrTQMHOCZv29jD+srJJ4l7RneX7Zsg9dbxLCpkjuXzR
         WL4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fBCjRdO6ZUYfFXcJUJ16vqsWOlK8LDenzaLFInuWfog=;
        b=ftPES7YJjqhnlbPlGgofPgbqRwYBizNSp2LBEE8bW2slM4rxxiyIA4sl6RAcPx32+5
         PlAJMZii2YV4e1KY8+Y22QdMEftf1sljk6TGG/mgskLeWzLaNFMTCTtnsazuXKBFsakV
         6dtrN/SxTu6DUXBkniN6fw3/hm6VkXappxoWZ1wKJJ7RPj2a140rZZXvh/zpNAoGHW/M
         aFVBCq5mqELyWvmFza25zI5pkGcyWwetWh8bPPke1HTj4seaiW4ytDOnqIEH0dH2j1s/
         GHkEh/rOU5suOi1y9WFay2hqmvk5bmR9sm/8XGBgZWT+hMVQu0u39G6kb1BzQdC2V1vU
         jHeA==
X-Gm-Message-State: ANoB5pkZtSTkBzqpE7N/qCDg516aswrZcMK7PAVzbTdLi7IIADzosmVm
        eYT2A6dP1zbDBPu6rX/uTWs0me2CWpP0maHpHeKb5w==
X-Google-Smtp-Source: AA0mqf7C9Ksb/ZxnjDz8QO+aOPP4gjCsXNmGSWSbl4qDyTEiuNcb6GIeLUcEi0vJCClM7ZJc3Vmj3/X4z07TcPSOt+0=
X-Received: by 2002:a2e:9c59:0:b0:26f:dfb2:9bfd with SMTP id
 t25-20020a2e9c59000000b0026fdfb29bfdmr8575794ljj.455.1668615816127; Wed, 16
 Nov 2022 08:23:36 -0800 (PST)
MIME-Version: 1.0
References: <20221103152318.88354-1-pgonda@google.com> <Y258U+8oF/eo14U+@zn.tnic>
 <CAMkAt6o-jcG7u1=zw4jJp5evrO4sFJR-iG_ApF7LhT+7c55_Wg@mail.gmail.com> <Y3TVcJnQ/Ym6dGz2@zn.tnic>
In-Reply-To: <Y3TVcJnQ/Ym6dGz2@zn.tnic>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 16 Nov 2022 09:23:24 -0700
Message-ID: <CAMkAt6qQmkufbuotzMA4bMJaA4uBFMdk8w7a3X+OH3JaOdFepA@mail.gmail.com>
Subject: Re: [PATCH V4] virt: sev: Prevent IV reuse in SNP guest driver
To:     Borislav Petkov <bp@suse.de>
Cc:     thomas.lendacky@amd.com, Dionna Glaze <dionnaglaze@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 5:20 AM Borislav Petkov <bp@suse.de> wrote:
>
> On Tue, Nov 15, 2022 at 02:47:31PM -0700, Peter Gonda wrote:
> > > > +      * certificate data buffer retry the same guest request witho=
ut the
> > > > +      * extended data request.
> > > > +      */
> > > > +     if (exit_code =3D=3D SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> > > > +         err =3D=3D SNP_GUEST_REQ_INVALID_LEN) {
> > > > +             const unsigned int certs_npages =3D snp_dev->input.da=
ta_npages;
> > > > +
> > > > +             exit_code =3D SVM_VMGEXIT_GUEST_REQUEST;
> > > > +             rc =3D snp_issue_guest_request(exit_code, &snp_dev->i=
nput, &err);
> > > > +
> > > > +             err =3D SNP_GUEST_REQ_INVALID_LEN;
> > >
> > > Huh, why are we overwriting err here?
> >
> > I have added a comment for the next revision.
> >
> > We are overwriting err here so that userspace is alerted that they
> > supplied a buffer too small.
>
> Sure but you're not checking rc either. What if that reissue fails for
> whatever other reason? -EIO for example...

If we get any error here we have to wipe the VMPCK here so I thought
this always override @err was OK.

I can update this to only override @err if after the secondary
SVM_VMGEXIT_GUEST_REQUEST rc and err are OK. Thoughts?

>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Software Solutions Germany GmbH
> GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
> (HRB 36809, AG N=C3=BCrnberg)
