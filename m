Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F326102B2
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236890AbiJ0UbA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiJ0Ua5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:30:57 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2253C6F26C
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:30:56 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id d3so5535756ljl.1
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RJhLmmsZGJ8bUFvXGrjhxjigTY7tssuM34NIcqRQJks=;
        b=ko4N/PqiVlcVf7rPdTn90/c1YL7CHD4kbLrdcKcGWYTUUSMtlKMiKyWHA+wDDKm3Ri
         9e+QndcW1iHPHRjxD1ZSz74bPfh7+NQfvegupvFlxKBAE57swePOCKRNOtu8w+V5/LIh
         oxfHuONcO0Ik1awpXYSMKm5/Us+dUNf4euurzQPxHHKyJd0J2aZg6aMTq63yWe/zpUHR
         BdwcHWaYJTXY9nY7H0cZ5ZFnP+HjhVQMyXizdrg693dGmkkh+NZ1U3pB4zQGTKXjYAq1
         O+7ty+Tq6vl57BKFDpOmZSjo8wIv9q+d+D2+wILbB19dg5S/gJyRJ3rpAwvrWr8JlqCE
         oGcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RJhLmmsZGJ8bUFvXGrjhxjigTY7tssuM34NIcqRQJks=;
        b=Mkm1T4NbLXotrjeuXhfWNCa2GgrFQ1HUgdvlJPVcDl6HbwdCSo0P7Bphsrs1oAtLQ7
         tAiWeZq8WAsi479VUqT9oDs7YM77Xus2KRYX+6wHLY03Kv4sxPzDEuiifqDxhHyWLr3l
         UV2MNNstnyVTcpt4lh97fAkrWqsSNAjDIAAnLJEELOL+zWg/+3RwGhRn5a0c6dClNop5
         f07DSzxKJtFY6rg3ciQBhRF65gSjrJbVTdM+QsafRgcgj9ry/d6UuLAlshnWftvnBLk/
         IFAzmmaQX46iory2BkIR/Vxu3yItxvcHdshEw6u7vDpIVrdOrUHfAB43IZ7HxEBMejI6
         KEdw==
X-Gm-Message-State: ACrzQf3VoW2wGgsyF/fzCcrRmCtR/9/E5Ku/moro3/2jqkus51YKoHxJ
        LOD9WIefI4ua1s7oz1vafHKTeOg3GE4l7QMUW5CN0A==
X-Google-Smtp-Source: AMsMyM5aP9GDCjgbJ8RdmCuiz8kw86pAQT51ja8FqsFb2OPVlHcT9WXJ4I4mEt7VBa1Y42QK1pGfOAzB7FUqg0u98iE=
X-Received: by 2002:a05:651c:1a0a:b0:26f:ef12:9a42 with SMTP id
 by10-20020a05651c1a0a00b0026fef129a42mr20984010ljb.457.1666902654247; Thu, 27
 Oct 2022 13:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20221027150558.722062-1-pgonda@google.com> <20221027150558.722062-2-pgonda@google.com>
 <10e7e8df-69ba-c1bc-1f94-c77fe64774ab@amd.com> <CAMkAt6qzW0oW=2Mvq0uO+ccwRyYcRAkDoF47mH4hMET5wASzsQ@mail.gmail.com>
In-Reply-To: <CAMkAt6qzW0oW=2Mvq0uO+ccwRyYcRAkDoF47mH4hMET5wASzsQ@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 27 Oct 2022 14:30:42 -0600
Message-ID: <CAMkAt6oWmX7iOe_vFKyrRZRbiyuNjO6GoSjSqExc5VPKcnOtDg@mail.gmail.com>
Subject: Re: [PATCH V3 1/2] virt: sev: Prevent IV reuse in SNP guest driver
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     Dionna Glaze <dionnaglaze@google.com>,
        Borislav Petkov <bp@suse.de>,
        Michael Roth <michael.roth@amd.com>,
        Haowen Bai <baihaowen@meizu.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Oct 27, 2022 at 2:10 PM Peter Gonda <pgonda@google.com> wrote:
>
> On Thu, Oct 27, 2022 at 12:06 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
> >
> > On 10/27/22 10:05, Peter Gonda wrote:
> > > The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> > > communicate securely with each other. The IV to this scheme is a
> > > sequence number that both the ASP and the guest track. Currently this
> > > sequence number in a guest request must exactly match the sequence
> > > number tracked by the ASP. This means that if the guest sees an error
> > > from the host during a request it can only retry that exact request or
> > > disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> > > reuse see:
> > > https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> > >
> > > To handle userspace querying the cert_data length. Instead of requesting
> > > the cert length from userspace use the size of the drivers allocated
> > > shared buffer. Then copy that buffer to userspace, or give userspace an
> > > error depending on the size of the buffer given by userspace.
> > >
> > > Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > Reported-by: Peter Gonda <pgonda@google.com>
> > > Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
> > > Cc: Borislav Petkov <bp@suse.de>
> > > Cc: Tom Lendacky <thomas.lendacky@amd.com>
> > > Cc: Michael Roth <michael.roth@amd.com>
> > > Cc: Haowen Bai <baihaowen@meizu.com>
> > > Cc: Yang Yingliang <yangyingliang@huawei.com>
> > > Cc: Marc Orr <marcorr@google.com>
> > > Cc: David Rientjes <rientjes@google.com>
> > > Cc: Ashish Kalra <Ashish.Kalra@amd.com>
> > > Cc: linux-kernel@vger.kernel.org
> > > Cc: kvm@vger.kernel.org
> > > ---
> > >   drivers/virt/coco/sev-guest/sev-guest.c | 93 ++++++++++++++++---------
> > >   1 file changed, 62 insertions(+), 31 deletions(-)
> > >
> > > diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> > > index f422f9c58ba7..8c54ea84bc57 100644
> > > --- a/drivers/virt/coco/sev-guest/sev-guest.c
> > > +++ b/drivers/virt/coco/sev-guest/sev-guest.c
> > > @@ -41,7 +41,7 @@ struct snp_guest_dev {
> > >       struct device *dev;
> > >       struct miscdevice misc;
> > >
> > > -     void *certs_data;
> > > +     u8 (*certs_data)[SEV_FW_BLOB_MAX_SIZE];
> > >       struct snp_guest_crypto *crypto;
> > >       struct snp_guest_msg *request, *response;
> > >       struct snp_secrets_page_layout *layout;
> > > @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> > >       return true;
> > >   }
> > >
> > > +/*
> > > + * If we receive an error from the host or ASP we have two options. We can
> > > + * either retry the exact same encrypted request or we can discontinue using the
> > > + * VMPCK.
> > > + *
> > > + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> > > + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> > > + * cannot tolerate IV reuse.
> > > + *
> > > + * The ASP FW v1.51 only increments the sequence numbers on a successful
> > > + * guest<->ASP back and forth and only accepts messages at its exact sequence
> > > + * number.
> > > + *
> > > + * So if we were to reuse the sequence number the encryption scheme is
> > > + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> > > + * reject our request.
> > > + */
> > >   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> > >   {
> > > +     dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> > > +               vmpck_id);
> > >       memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> > >       snp_dev->vmpck = NULL;
> > >   }
> > > @@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
> > >       if (fw_err)
> > >               *fw_err = err;
> > >
> > > -     if (rc)
> > > -             return rc;
> > > +     if (rc) {
> > > +             dev_alert(snp_dev->dev,
> > > +                       "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> > > +                       rc, *fw_err);
> > > +             goto disable_vmpck;
> > > +     }
> >
> > Realize that snp_issue_guest_request() will return -EIO in the case that
> > the returned SW_EXITINFO2 value is SNP_GUEST_REQ_INVALID_LEN. So all the
> > work you do below in get_ext_report() doesn't matter because you end up
> > disabling the key here.
> >
> > So maybe this patch should be split up and parts of it added to the second
> > patch (but that patch seems like it would still hit this issue because
> > -EIO is still returned.
> >
>
> Ack I see that. My testing didn't catch this since I realized I didn't
> actually load any certificate data into the host. After doing so my
> testing catches this bug.
>
> I agree with Dionna's comments on 2/2. My suggestion would be to keep
> the constraint that either handle_guest_request() leaves the sequence
> number in a good state or disables the VMPCK. After seeing her V4
> series I suggest we take this patch and follow up on the certificate
> querying with the further changes to snp_issue_guest_request().
> Thoughts?

Actually we want the V2 version of this patch, which forces userspace
to use 4 pages and therefore doesn't let a short userspace request
corrupt the sequence numbers.
