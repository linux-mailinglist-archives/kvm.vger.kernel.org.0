Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5251570713
	for <lists+kvm@lfdr.de>; Mon, 11 Jul 2022 17:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiGKP2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 11:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiGKP2U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 11:28:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2817C275C0
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 08:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657553294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AQ9AFgjAq9AFWyJhWhhuGWEoRzdPmRiYM2CqArRFNmo=;
        b=IuLweYScR4mLFkhU/v4xp5cwrizEPSs0cXl4i0azFTuffSvYTpCc1PXTMORiApbHFWfQ5j
        Br0FbhrFEtqpLDqOf3LtiniobO2eXw+GsDIwK9WqFbIVYEZbNbdiqvTHCCsKjYL/peHwKp
        FmZvqmtV8Mvc7b75vZcDATfuijX/wyI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-sZRYSwjUOV--3C-eegOFiQ-1; Mon, 11 Jul 2022 11:28:12 -0400
X-MC-Unique: sZRYSwjUOV--3C-eegOFiQ-1
Received: by mail-wr1-f69.google.com with SMTP id l11-20020adfbd8b000000b0021d754b84c5so744625wrh.17
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 08:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AQ9AFgjAq9AFWyJhWhhuGWEoRzdPmRiYM2CqArRFNmo=;
        b=ko3cX3zEqA+5iPfvCjM7jdhfkkyl+cjAq2tcMKO3vEVhSXtDp41/N3RHkeTRiqOCbQ
         H8JFH/GRUJP3kyylHiMGyYyhnDdDn/09PcdIgD1jbVnBOmI/olveVqbAidYpOK0SseXi
         tvzfY0HvVv2n5nYNXfRoGhr00r2HVmPaYOxUs2C+H1blpwknbRmpRdcR+b0/6494IkqW
         vYE+lnAUyRsiHj6+GHb7qOpBHvSkgfzVfenPpaxy+4UaxZAlkGIJ5wXjhd9qa8JFkLeS
         Cix3Az+F7X6w+UKxkK99Ag9vicy55cV08+51dvIVbCpMescdsAtT3utAKdNwWqkcOV+7
         J68g==
X-Gm-Message-State: AJIora9yuN+W6QyXHAAP/7tvGqUNYaMmEv+7NOkmHVe9Cnb9XkIgVOSh
        tAThW7Wkk3ySU2MF3psn7WgPlxTuUBFlX6ipMQv8B2ESdHDM/IVDoVXGgOXzypmtWYfr+IQlWYy
        LkoYhZTTce0uG
X-Received: by 2002:a5d:47a8:0:b0:21b:a318:2c31 with SMTP id 8-20020a5d47a8000000b0021ba3182c31mr17271983wrb.463.1657553290622;
        Mon, 11 Jul 2022 08:28:10 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1umoOE6F3TF/C4rCdhEN4YxFLp/CjqND8ZeK2+w2mCDb4Dh3IREsmxv9tEeCNjhbEJdT4uSfw==
X-Received: by 2002:a5d:47a8:0:b0:21b:a318:2c31 with SMTP id 8-20020a5d47a8000000b0021ba3182c31mr17271965wrb.463.1657553290404;
        Mon, 11 Jul 2022 08:28:10 -0700 (PDT)
Received: from work-vm (cpc109025-salf6-2-0-cust480.10-2.cable.virginm.net. [82.30.61.225])
        by smtp.gmail.com with ESMTPSA id j16-20020adfff90000000b0021d76a1b0e3sm6039975wrr.6.2022.07.11.08.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 08:28:09 -0700 (PDT)
Date:   Mon, 11 Jul 2022 16:28:07 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 0/2] arm: enable MTE for QEMU + kvm
Message-ID: <YsxBh3bJmbF8MvsJ@work-vm>
References: <20220707161656.41664-1-cohuck@redhat.com>
 <YswkdVeESqf5sknQ@work-vm>
 <87o7xv660k.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o7xv660k.fsf@redhat.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Cornelia Huck (cohuck@redhat.com) wrote:
> On Mon, Jul 11 2022, "Dr. David Alan Gilbert" <dgilbert@redhat.com> wrote:
> 
> > * Cornelia Huck (cohuck@redhat.com) wrote:
> >> For kvm, mte stays off by default; this is because migration is not yet
> >> supported (postcopy will need an extension of the kernel interface, possibly
> >> an extension of the userfaultfd interface), and turning on mte will add a
> >> migration blocker.
> >
> > My assumption was that a normal migration would need something as well
> > to retrieve and place the MTE flags; albeit not atomically.
> 
> There's KVM_ARM_MTE_COPY_TAGS, which should be sufficient to move tags
> around for normal migration.
> 
> >
> >> My biggest question going forward is actually concerning migration; I gather
> >> that we should not bother adding something unless postcopy is working as well?
> >
> > I don't think that restriction is fair on you; just make sure
> > postcopy_ram_supported_by_host gains an arch call and fails cleanly;
> > that way if anyone tries to enable postcopy they'll find out with a
> > clean fail.
> 
> Ok, if simply fencing off postcopy is fine, we can try to move forward
> with what we have now. The original attempt at
> https://lore.kernel.org/all/881871e8394fa18a656dfb105d42e6099335c721.1615972140.git.haibo.xu@linaro.org/
> hooked itself directly into common code; maybe we should rather copy the
> approach used for s390 storage keys (extra "device") instead?

I don't understand how a separate device would keep the idea of page
changed flags coherent with the main RAM that the tags correspond to.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

