Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B03F24E6F83
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 09:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355186AbiCYIgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 04:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351420AbiCYIgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 04:36:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 23A3049F11
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 01:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648197278;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WrdyQb+Uv/9WNCCF+/twDW82DyGh5taXBM+hU8QrQjU=;
        b=G13UsxorlXqmpZ4PHnHy2S2gm2wDVakLQX1qexIG0xnnpyAN6I6RSvIuCnqiwYP1SN0JFV
        v7TKZcQ4FyBnC6BaSLJanf4SUnhXkE+B3qHC3Ye6Q3u2pu5GeY3c5LBCUGdPO1tSTvfH5f
        V5B3E1pO836KOJMzfWll2BPWo0Gb1Sw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-122-5v8A_A3SOPWoIFuGiFe96w-1; Fri, 25 Mar 2022 04:34:37 -0400
X-MC-Unique: 5v8A_A3SOPWoIFuGiFe96w-1
Received: by mail-wm1-f69.google.com with SMTP id z16-20020a05600c0a1000b0038bebbd8548so4940730wmp.3
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 01:34:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :user-agent:reply-to:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WrdyQb+Uv/9WNCCF+/twDW82DyGh5taXBM+hU8QrQjU=;
        b=aTDrF7mLr6oYBsrk+2VBAwjAkpJGUdIAINZKE6o18+tkjJlu0KN940ulF7KgCGb2iz
         oRhW2K2RvBsvbOQJ0eek6hKJQTxlCV9Ke27isL28NPTELrO3kOacy+Toy5AAFCiEmx0K
         z209sfiMswxYAWY17VHDj2FWGYnJap+TrVbcsBnEfZAhXy+I6M6kuc6pe3BMiCtT6zke
         SVWp06vGPoigN6ppnT0pTB0bL59gEOB+v5IyEiZLTdN4A/5CBWasMFw5ubxvxC8ujzl+
         uT6aU20QdcllHAPu9MhNA7y2fi+pXhqyxcTYAY9FpqTmnRyS+C/MrbEDkmtBknclJO3v
         ye3Q==
X-Gm-Message-State: AOAM531mfqqsGx8lyji+oQpQszSfn+mqcgd+1OWbHScKmupjEvgAeA31
        eI9AwghYKnd3sEIuBHxoXKpKygSicFdgnIJNnk7Jg2ol4hbsKEcmRfkDk2++dtmhnKkFfAxFyez
        ZvycXOzDnHpNH
X-Received: by 2002:a05:600c:35cc:b0:38c:6d25:f4ad with SMTP id r12-20020a05600c35cc00b0038c6d25f4admr8589601wmq.127.1648197275905;
        Fri, 25 Mar 2022 01:34:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9JSpWRk2LRgPXv74WxLi/tJwLkB8FqTAgxuuKq0EB245CfQf7Z1SW9Vl2nq04SgzY/fLhZw==
X-Received: by 2002:a05:600c:35cc:b0:38c:6d25:f4ad with SMTP id r12-20020a05600c35cc00b0038c6d25f4admr8589572wmq.127.1648197275657;
        Fri, 25 Mar 2022 01:34:35 -0700 (PDT)
Received: from localhost ([47.63.10.52])
        by smtp.gmail.com with ESMTPSA id n8-20020a5d5988000000b00203d5f1f3e4sm4828654wri.105.2022.03.25.01.34.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 01:34:35 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     marcandre.lureau@redhat.com
Cc:     qemu-devel@nongnu.org, Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <v.sementsov-og@mail.ru>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Yuval Shaia <yuval.shaia.ml@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Colin Xu <colin.xu@intel.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Stefan Weil <sw@weilnetz.de>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs),
        qemu-block@nongnu.org (open list:Block layer core),
        qemu-s390x@nongnu.org (open list:S390 general arch...),
        qemu-ppc@nongnu.org (open list:New World (mac99)),
        haxm-team@intel.com (open list:X86 HAXM CPUs)
Subject: Re: [PATCH 11/32] Replace qemu_real_host_page variables with
 inlined functions
In-Reply-To: <20220323155743.1585078-12-marcandre.lureau@redhat.com>
        (marcandre lureau's message of "Wed, 23 Mar 2022 19:57:22 +0400")
References: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
        <20220323155743.1585078-12-marcandre.lureau@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 25 Mar 2022 09:34:33 +0100
Message-ID: <87k0cie8h2.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

marcandre.lureau@redhat.com wrote:
> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>
> Replace the global variables with inlined helper functions. getpagesize()=
 is very
> likely annotated with a "const" function attribute (at least with glibc),=
 and thus
> optimization should apply even better.
>
> This avoids the need for a constructor initialization too.
>
> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>

I see what you are tyring to do here.

But once here, why aren't we just calling getpagesize() and call it a
day?  I can't see what advantage has to have this other name for this
function, and as you are already changing all its uses anyways.

Once there, I can see that qemu_real_host_page_mask is used (almost)
everywhere as (vfio code use the real value):

    foo & qemu_real_host_page_mask()

or

    foo & ~qemu_real_host_page_mask()

And no, I don't have any good names for this macros.

Anyways, if you don't like the suggestion, your changes are better that
we already have, so ...

Reviewed-by: Juan Quintela <quintela@redhat.com>

