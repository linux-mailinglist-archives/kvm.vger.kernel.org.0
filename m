Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A229F628B25
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 22:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237367AbiKNVMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 16:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237585AbiKNVMD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 16:12:03 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B466B35
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:12:02 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id j16so21369683lfe.12
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 13:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u5c3d/R+hycXfam13b38ezR7QlhNG6bgVdrzTMUaN84=;
        b=gLgG3OpNKby3lv5oeGlMTQIBqbd4rH+hf5lU9WR9tNVSZhRpz8Eg+IiiKlc5MmvGud
         jqZKDAXH6MxopShoaNjBJIU6NrYJTcIFmDf50fztvHW3i88Hn+h8rFsjBuLSS8Huh4Tw
         Wb76NZ8CKNxc3c/Kayxyjg9WhaYMPp9jcDs5kvGrsnZ+tTyhuKYf8ANzuEEeNE5q/Cms
         T1+S0GxM1LplONxje+wQ9NsRyhavaQf/LRyRsRRKSgIAEJ+myBf+MgVjK7lQgcnK7++b
         pYknsRlYqNh6ArZsj0KEtYqVZ74/f+v6kypIxZ0qzTN3XMp6J6hzcBNIIgrNLn/Gx5hY
         wqzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5c3d/R+hycXfam13b38ezR7QlhNG6bgVdrzTMUaN84=;
        b=PGRlrenkgvmbUP0pM2Ec5z2uERzWk4dKYQC0k+us4+e1EF9kqoQ81qiXXj2U7wteno
         czKWbfqMU6Vl+O1FpPepgENF+P303J/5KklK2McrpZWKZ1HP/bWE7CsWITeoyycnM84l
         6M/mEA/qEWV0OuUDbyqPcKYBqMXj6Zz75I9DL9sk1ZqJqDbkz4u9Z/tVq9GlkD4+Jm1S
         7re4g77UQVysmbWRZAjO3/kczIlz68IYVYV/p+Dk6PnkUGqVGwYHcd6AapLcF2sCBGFm
         tdcPT5wbb5+q6SsVSjKW18BK2nEYOpmdPt5QsVaoWZ3moOoQLW/P8h8sM2aKpfnh2xBP
         0IkQ==
X-Gm-Message-State: ANoB5pmQrIK/sgjhHC2bxf3m/DehqezGBF0/6xhqSFJX7wK1Z3l2M2Pm
        zNRgP6roNAPUWQrYv6C4XiEm+lJUD02mH3baQT36mQ==
X-Google-Smtp-Source: AA0mqf4zUvucihZccorNDZ1AY4kY2YidMwjV9r0sqjVG0rZ0b4dE+xzTXK4ef0/H4Xqz3BIKETnfQpjDZ85U8fUiT90=
X-Received: by 2002:a05:6512:2033:b0:4b0:8a8f:8e28 with SMTP id
 s19-20020a056512203300b004b08a8f8e28mr4329430lfs.682.1668460320419; Mon, 14
 Nov 2022 13:12:00 -0800 (PST)
MIME-Version: 1.0
References: <20221103152318.88354-1-pgonda@google.com> <Y258U+8oF/eo14U+@zn.tnic>
In-Reply-To: <Y258U+8oF/eo14U+@zn.tnic>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 14 Nov 2022 14:11:48 -0700
Message-ID: <CAMkAt6p2zXnE-ew+pJk_UpZAEFZFdCOPThNn3hSFqYOQG81t-g@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 11, 2022 at 9:46 AM Borislav Petkov <bp@suse.de> wrote:
>
> On Thu, Nov 03, 2022 at 08:23:18AM -0700, Peter Gonda wrote:
> > The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
>
> ASP?
>
> That must be the AMD Secure Processor or so but pls write it out.
>
> > communicate securely with each other. The IV to this scheme is a
> > sequence number that both the ASP and the guest track. Currently this
> > sequence number in a guest request must exactly match the sequence
> > number tracked by the ASP. This means that if the guest sees an error
> > from the host during a request it can only retry that exact request or
> > disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> > reuse see:
> > https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/docum=
ents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
>
> Right, how stable will that link be?
>
> IOW, perhaps quote the paper name and authors so that people can find it
> on their own.
>
> > To handle userspace querying the cert_data length handle_guest_request(=
)
> > now: saves the number of pages required by the host, retries the reques=
t
>
> This needs to sound like this:
>
> "In order to address this, save the number of pages ..."
>
> IOW, as the docs say:
>
> "Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> to do frotz", as if you are giving orders to the codebase to change
> its behaviour."

Thanks for detailed review. Working on cleaning up the text for a V5.

>
> > without requesting the extended data, then returns the number of pages
> > required.
> >
> > Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
>
> I'm guessing this needs to go to stable?
>
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reported-by: Peter Gonda <pgonda@google.com>
> > Cc: Dionna Glaze <dionnaglaze@google.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > Cc: Michael Roth <michael.roth@amd.com>
> > Cc: Haowen Bai <baihaowen@meizu.com>
> > Cc: Yang Yingliang <yangyingliang@huawei.com>
> > Cc: Marc Orr <marcorr@google.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> > Cc: linux-kernel@vger.kernel.org
> > Cc: kvm@vger.kernel.org
> > ---
> > Tested by placing each of the guest requests: attestation quote,
> > extended attestation quote, and get key. Then tested the extended
> > attestation quote certificate length querying.
> >
> > V4
> >  * As suggested by Dionna moved the extended request retry logic into
> >    the driver.
> >  * Due to big change in patch dropped any reviewed-by tags.
> >
> > ---
> >  drivers/virt/coco/sev-guest/sev-guest.c | 70 +++++++++++++++++++------
> >  1 file changed, 53 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coc=
o/sev-guest/sev-guest.c
> > index f422f9c58ba79..7dd6337ebdd5b 100644
> > --- a/drivers/virt/coco/sev-guest/sev-guest.c
> > +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> > @@ -41,7 +41,7 @@ struct snp_guest_dev {
> >       struct device *dev;
> >       struct miscdevice misc;
> >
> > -     void *certs_data;
> > +     u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
> >       struct snp_guest_crypto *crypto;
> >       struct snp_guest_msg *request, *response;
> >       struct snp_secrets_page_layout *layout;
> > @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp=
_dev)
> >       return true;
> >  }
> >
> > +/*
> > + * If we receive an error from the host or ASP we have two options. We=
 can
>
> Please use passive voice in your commit message: no "we" or "I", etc,
> and describe your changes in imperative mood.
>
> Bottom line is: personal pronouns are ambiguous in text, especially with
> so many parties/companies/etc developing the kernel so let's avoid them
> please.
>
> > + * either retry the exact same encrypted request or we can discontinue=
 using the
> > + * VMPCK.
> > + *
> > + * This is because in the current encryption scheme GHCB v2 uses AES-G=
CM to
> > + * encrypt the requests. The IV for this scheme is the sequence number=
. GCM
> > + * cannot tolerate IV reuse.
> > + *
> > + * The ASP FW v1.51 only increments the sequence numbers on a successf=
ul
> > + * guest<->ASP back and forth and only accepts messages at its exact s=
equence
> > + * number.
> > + *
> > + * So if we were to reuse the sequence number the encryption scheme is
> > + * vulnerable. If we encrypt the sequence number for a fresh IV the AS=
P will
> > + * reject our request.
> > + */
> >  static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> >  {
> > +     dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reu=
se.\n",
> > +               vmpck_id);
> >       memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> >       snp_dev->vmpck =3D NULL;
> >  }
> > @@ -323,32 +342,49 @@ static int handle_guest_request(struct snp_guest_=
dev *snp_dev, u64 exit_code, in
> >
> >       /* Call firmware to process the request */
> >       rc =3D snp_issue_guest_request(exit_code, &snp_dev->input, &err);
> > +
> > +     /*
> > +      * If the extended guest request fails due to having to small of =
a
>
> "... too small... "
>
> > +      * certificate data buffer retry the same guest request without t=
he
> > +      * extended data request.
> > +      */
> > +     if (exit_code =3D=3D SVM_VMGEXIT_EXT_GUEST_REQUEST &&
> > +         err =3D=3D SNP_GUEST_REQ_INVALID_LEN) {
> > +             const unsigned int certs_npages =3D snp_dev->input.data_n=
pages;
> > +
> > +             exit_code =3D SVM_VMGEXIT_GUEST_REQUEST;
> > +             rc =3D snp_issue_guest_request(exit_code, &snp_dev->input=
, &err);
> > +
> > +             err =3D SNP_GUEST_REQ_INVALID_LEN;
>
> Huh, why are we overwriting err here?
>
> > +             snp_dev->input.data_npages =3D certs_npages;
> > +     }
> > +
> >       if (fw_err)
> >               *fw_err =3D err;
> >
> > -     if (rc)
> > -             return rc;
> > +     if (rc) {
> > +             dev_alert(snp_dev->dev,
> > +                       "Detected error from ASP request. rc: %d, fw_er=
r: %llu\n",
> > +                       rc, *fw_err);
> > +             goto disable_vmpck;
> > +     }
> >
> > -     /*
> > -      * The verify_and_dec_payload() will fail only if the hypervisor =
is
> > -      * actively modifying the message header or corrupting the encryp=
ted payload.
> > -      * This hints that hypervisor is acting in a bad faith. Disable t=
he VMPCK so that
> > -      * the key cannot be used for any communication. The key is disab=
led to ensure
> > -      * that AES-GCM does not use the same IV while encrypting the req=
uest payload.
> > -      */
> >       rc =3D verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
> >       if (rc) {
> >               dev_alert(snp_dev->dev,
> > -                       "Detected unexpected decode failure, disabling =
the vmpck_id %d\n",
> > -                       vmpck_id);
> > -             snp_disable_vmpck(snp_dev);
> > -             return rc;
> > +                       "Detected unexpected decode failure from ASP. r=
c: %d\n",
> > +                       rc);
> > +             goto disable_vmpck;
> >       }
> >
> >       /* Increment to new message sequence after payload decryption was=
 successful. */
> >       snp_inc_msg_seqno(snp_dev);
> >
> >       return 0;
> > +
> > +disable_vmpck:
> > +     snp_disable_vmpck(snp_dev);
> > +     return rc;
> >  }
> >
> >  static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_=
request_ioctl *arg)
> > @@ -676,7 +712,7 @@ static int __init sev_guest_probe(struct platform_d=
evice *pdev)
> >       if (!snp_dev->response)
> >               goto e_free_request;
> >
> > -     snp_dev->certs_data =3D alloc_shared_pages(dev, SEV_FW_BLOB_MAX_S=
IZE);
> > +     snp_dev->certs_data =3D alloc_shared_pages(dev, sizeof(*snp_dev->=
certs_data));
>
> What's that change for?
>
> I went searching for that ->certs_data only ot realize that it is an
> array of size of SEV_FW_BLOB_MAX_SIZE elems.

Do you want this change reverted? I liked the extra readability of the
sizeof(*snp_dev->certs_data) but its unnecessary for this change.

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> SUSE Software Solutions Germany GmbH
> GF: Ivo Totev, Andrew Myers, Andrew McDonald, Martje Boudien Moerman
> (HRB 36809, AG N=C3=BCrnberg)
