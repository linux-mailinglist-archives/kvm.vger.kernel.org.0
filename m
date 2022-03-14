Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9164D8F88
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 23:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245592AbiCNW2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 18:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233289AbiCNW2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 18:28:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2BFCE3D481
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647296845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TpdoUAGo4Vbq1pnSaeeo5GoHtu72AeubKTd62jeGUEg=;
        b=AWBM06LXajqIWRkHCJCbSH0Ew/l22vWd+VIYeSA/GIPtpDh3BSfPt610bH4k8ENZgvNwwJ
        eYfkjrDrBwCykU8/vctH3dAlU3rD0MelqvmKpu+aHAgQgh7jeNzsiLL0MHsLGlbnIAE60B
        taCjnezZlLTk03Qxdl/EjG9A4PX96FQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-qAgTEqKoNSWsVKCFGJ_LkQ-1; Mon, 14 Mar 2022 18:27:24 -0400
X-MC-Unique: qAgTEqKoNSWsVKCFGJ_LkQ-1
Received: by mail-ed1-f69.google.com with SMTP id i17-20020aa7c711000000b00415ecaefd07so9515580edq.21
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 15:27:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=TpdoUAGo4Vbq1pnSaeeo5GoHtu72AeubKTd62jeGUEg=;
        b=RFDZb+lRlPZJAZfcQ5ohG0fhgImfR7Yqm8WYGpKad8VX05jGJMcKIXEKs3neqG5kl6
         0IQq/wPcC71FCT3Q+fR3T9+ajzASNYTf4VF3MoJRAG4hkV+0TgL15NT8jAWc2TKQzMUT
         bthkN7RBvcdVxLIaNtCK/spg60zCz2Z6cM35Fm9XXAcP6qRbKwgx3D0vruDDx51b30KJ
         erFtwQCQhTnMyMZ+zEvm3EkDTvizG0zsfaDFLadmxY7p2mJ7pmyvJJsNrP1ig2C2t45K
         u+NC/HhC4EJI9qCjlSk74XtmraAkwI2ioSQ+Rp3FpHeITQTtlIqA/Qe4JnLoWQo5rFnB
         WB/g==
X-Gm-Message-State: AOAM5303YlmBd+Y/XvrA8VGzIASDOM2BYwiKbFeI9Bp5DKN7ICimxdiD
        y9sYA57adsEgZ4kwXQH3EcyhJec+KMn8utfW/7KvvlGRb7qK5ZrqPEQcQyXDc/3Sg6k6NMKaGwz
        37DciLOPuNehM
X-Received: by 2002:a05:6402:2365:b0:415:ed07:70de with SMTP id a5-20020a056402236500b00415ed0770demr22875102eda.150.1647296842829;
        Mon, 14 Mar 2022 15:27:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5ACN3joDR8n40Q4f2vCCOEIdwEoXTxWtPak6qyFiuNZ82SR61qjTgXiDS0VURz0vTmGtUig==
X-Received: by 2002:a05:6402:2365:b0:415:ed07:70de with SMTP id a5-20020a056402236500b00415ed0770demr22875090eda.150.1647296842622;
        Mon, 14 Mar 2022 15:27:22 -0700 (PDT)
Received: from redhat.com ([176.12.250.92])
        by smtp.gmail.com with ESMTPSA id g23-20020a17090670d700b006ccfd4163f7sm7197673ejk.206.2022.03.14.15.27.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 15:27:22 -0700 (PDT)
Date:   Mon, 14 Mar 2022 18:27:17 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     qemu-devel@nongnu.org, Peter Xu <peterx@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Claudio Fontana <cfontana@suse.de>,
        Igor Mammedov <imammedo@redhat.com>,
        Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>
Subject: Re: [PATCH 2/4] intel_iommu: Support IR-only mode without DMA
 translation
Message-ID: <20220314182454-mutt-send-email-mst@kernel.org>
References: <20220314142544.150555-1-dwmw2@infradead.org>
 <20220314142544.150555-2-dwmw2@infradead.org>
 <20220314112001-mutt-send-email-mst@kernel.org>
 <9db2fb68447b27203e6e006f29e2b960565c37bb.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9db2fb68447b27203e6e006f29e2b960565c37bb.camel@infradead.org>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 14, 2022 at 03:45:47PM +0000, David Woodhouse wrote:
> On Mon, 2022-03-14 at 11:24 -0400, Michael S. Tsirkin wrote:
> > On Mon, Mar 14, 2022 at 02:25:42PM +0000, David Woodhouse wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > > 
> > > By setting none of the SAGAW bits we can indicate to a guest that DMA
> > > translation isn't supported. Tested by booting Windows 10, as well as
> > > Linux guests with the fix at https://git.kernel.org/torvalds/c/c40aaaac10
> > > 
> > > 
> > > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > > Reviewed-by: Peter Xu <peterx@redhat.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > 
> > this is borderline like a feature, but ...
> 
> It's the opposite of a feature — it's turning the feature *off* ;)

Right. Still - do you believe it's appropriate in soft freeze
and if yes why?

> > > 
> > > @@ -3627,12 +3628,17 @@ static void vtd_init(IntelIOMMUState *s)
> > >      s->next_frcd_reg = 0;
> > >      s->cap = VTD_CAP_FRO | VTD_CAP_NFR | VTD_CAP_ND |
> > >               VTD_CAP_MAMV | VTD_CAP_PSI | VTD_CAP_SLLPS |
> > > -             VTD_CAP_SAGAW_39bit | VTD_CAP_MGAW(s->aw_bits);
> > > +             VTD_CAP_MGAW(s->aw_bits);
> > >      if (s->dma_drain) {
> > >          s->cap |= VTD_CAP_DRAIN;
> > >      }
> > > -    if (s->aw_bits == VTD_HOST_AW_48BIT) {
> > > -        s->cap |= VTD_CAP_SAGAW_48bit;
> > > +    if (s->dma_translation) {
> > > +            if (s->aw_bits >= VTD_HOST_AW_39BIT) {
> > > +                    s->cap |= VTD_CAP_SAGAW_39bit;
> > > +            }
> > > +            if (s->aw_bits >= VTD_HOST_AW_48BIT) {
> > > +                    s->cap |= VTD_CAP_SAGAW_48bit;
> > > +            }
> > >      }
> > >      s->ecap = VTD_ECAP_QI | VTD_ECAP_IRO;
> > > 
> > 
> > 
> > ... this looks like you are actually fixing aw_bits < VTD_HOST_AW_39BIT,
> > right? So maybe this patch is ok like this since it also fixes a
> > bug. Pls add this to commit log though.
> 
> Nah, aw_bits cannot be < VTD_HOST_AW_39BIT. We explicitly check in
> vtd_decide_config(), and only 39 or 48 bits are supported,
> corresponding to 3-level or 4-level page tables.

Oh right. So not a bugfix then.

> The only time we'd want to *not* advertise 39-bit support is if we
> aren't advertising DMA translation at all. Which is the (anti-)feature
> introduced by this patch.
> 


