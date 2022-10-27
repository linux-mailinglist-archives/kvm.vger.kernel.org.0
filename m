Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E44E61026E
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiJ0ULY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236930AbiJ0ULE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:11:04 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F6D5FF61
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:11:00 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id g12so4530185lfh.3
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F8BavPFOAHXNO09BgfP4Q2HsQ7g6wEbyxvWgdnFD/5M=;
        b=JYpuyDLHs1elyZB84rUPtDpDc5Tze8rcHtDcDwg/aI7hO7sQ8JQlwLEHu98tyKxDgN
         rIZfEi5JJBP8HF5VB/RVwFkeHAKDWnnnnoHuJZb712KspOk/EBCLqqkJz952PIy4paUU
         +dn2WjDUcLoBHJ2U/g0ApXim9ursB0p+DIKGzfJ8iAucmxqbNhiPzlzzvI20GaadVPNs
         GcwL9Ty/zFL+FvPFQn5pkgboDchWUhd8qRM9Hz8SuHXmyMr2fuRqK9B9MLwV7jitP9mb
         SkJkw4DHYBfajlzc9Lp67LRfyNpoTgEvUuO/o0t2Zd+qyLdL/V7pL9Q/UVU4xX4N6mAM
         ig1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F8BavPFOAHXNO09BgfP4Q2HsQ7g6wEbyxvWgdnFD/5M=;
        b=yTKmWkYfXS4if7iETEq58/qTNa8yeDehe2Q9Dw3gKdcBOP32U+ag0qkCmzMedFKYSp
         Rpnta3YJI95aYzoNIP3IZTrDJnurEqLyL2Jdxr34DdsclGi4EEiqBGl6tHUbvb8c9gpm
         beNsiSGnDr0dVTFuEc8u1bLDRNVd7g/CIXAC5XrFeM1sB6J8hz6XiSZk0KN/7T65XFMn
         HAzPOiiDAckH9XeatL/VGTa/IoRjf4iHqXB5eERxlNI417OkQ6G2OnfQwAuHfpdRlS+Q
         zTWtd/nbEq6t+aVy3RJMczXye1Htv5xqYy8kDi2bUgVKuX+tjfiMKV52mGBAbTyZsp5O
         zT4g==
X-Gm-Message-State: ACrzQf0TeJ1hpSrthD02zWyrJ673lZOtiNpsZe6IMmApgSJ6RPbylC//
        lqWkftTfPsBkbTZToVfIVkBIevlqB6oX70ZhzpHqSg==
X-Google-Smtp-Source: AMsMyM4sMrItvaOQO4fUwqfRraRoLkSUR2YnOzX3N/94ueko/879dyN5xzHvi6zcExL6kGcJG7OyK6IJBQcQHnFNYeA=
X-Received: by 2002:a05:6512:2a91:b0:4a4:69aa:9160 with SMTP id
 dt17-20020a0565122a9100b004a469aa9160mr20269872lfb.313.1666901458915; Thu, 27
 Oct 2022 13:10:58 -0700 (PDT)
MIME-Version: 1.0
References: <20221027150558.722062-1-pgonda@google.com> <20221027150558.722062-2-pgonda@google.com>
 <10e7e8df-69ba-c1bc-1f94-c77fe64774ab@amd.com>
In-Reply-To: <10e7e8df-69ba-c1bc-1f94-c77fe64774ab@amd.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 27 Oct 2022 14:10:47 -0600
Message-ID: <CAMkAt6qzW0oW=2Mvq0uO+ccwRyYcRAkDoF47mH4hMET5wASzsQ@mail.gmail.com>
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

On Thu, Oct 27, 2022 at 12:06 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 10/27/22 10:05, Peter Gonda wrote:
> > The ASP and an SNP guest use a series of AES-GCM keys called VMPCKs to
> > communicate securely with each other. The IV to this scheme is a
> > sequence number that both the ASP and the guest track. Currently this
> > sequence number in a guest request must exactly match the sequence
> > number tracked by the ASP. This means that if the guest sees an error
> > from the host during a request it can only retry that exact request or
> > disable the VMPCK to prevent an IV reuse. AES-GCM cannot tolerate IV
> > reuse see:
> > https://csrc.nist.gov/csrc/media/projects/block-cipher-techniques/documents/bcm/comments/800-38-series-drafts/gcm/joux_comments.pdf
> >
> > To handle userspace querying the cert_data length. Instead of requesting
> > the cert length from userspace use the size of the drivers allocated
> > shared buffer. Then copy that buffer to userspace, or give userspace an
> > error depending on the size of the buffer given by userspace.
> >
> > Fixes: fce96cf044308 ("virt: Add SEV-SNP guest driver")
> > Signed-off-by: Peter Gonda <pgonda@google.com>
> > Reported-by: Peter Gonda <pgonda@google.com>
> > Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
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
> >   drivers/virt/coco/sev-guest/sev-guest.c | 93 ++++++++++++++++---------
> >   1 file changed, 62 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
> > index f422f9c58ba7..8c54ea84bc57 100644
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
> > @@ -67,8 +67,27 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
> >       return true;
> >   }
> >
> > +/*
> > + * If we receive an error from the host or ASP we have two options. We can
> > + * either retry the exact same encrypted request or we can discontinue using the
> > + * VMPCK.
> > + *
> > + * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
> > + * encrypt the requests. The IV for this scheme is the sequence number. GCM
> > + * cannot tolerate IV reuse.
> > + *
> > + * The ASP FW v1.51 only increments the sequence numbers on a successful
> > + * guest<->ASP back and forth and only accepts messages at its exact sequence
> > + * number.
> > + *
> > + * So if we were to reuse the sequence number the encryption scheme is
> > + * vulnerable. If we encrypt the sequence number for a fresh IV the ASP will
> > + * reject our request.
> > + */
> >   static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
> >   {
> > +     dev_alert(snp_dev->dev, "Disabling vmpck_id: %d to prevent IV reuse.\n",
> > +               vmpck_id);
> >       memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
> >       snp_dev->vmpck = NULL;
> >   }
> > @@ -326,29 +345,29 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
> >       if (fw_err)
> >               *fw_err = err;
> >
> > -     if (rc)
> > -             return rc;
> > +     if (rc) {
> > +             dev_alert(snp_dev->dev,
> > +                       "Detected error from ASP request. rc: %d, fw_err: %llu\n",
> > +                       rc, *fw_err);
> > +             goto disable_vmpck;
> > +     }
>
> Realize that snp_issue_guest_request() will return -EIO in the case that
> the returned SW_EXITINFO2 value is SNP_GUEST_REQ_INVALID_LEN. So all the
> work you do below in get_ext_report() doesn't matter because you end up
> disabling the key here.
>
> So maybe this patch should be split up and parts of it added to the second
> patch (but that patch seems like it would still hit this issue because
> -EIO is still returned.
>

Ack I see that. My testing didn't catch this since I realized I didn't
actually load any certificate data into the host. After doing so my
testing catches this bug.

I agree with Dionna's comments on 2/2. My suggestion would be to keep
the constraint that either handle_guest_request() leaves the sequence
number in a good state or disables the VMPCK. After seeing her V4
series I suggest we take this patch and follow up on the certificate
querying with the further changes to snp_issue_guest_request().
Thoughts?
