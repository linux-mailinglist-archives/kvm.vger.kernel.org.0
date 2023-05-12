Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1C700770
	for <lists+kvm@lfdr.de>; Fri, 12 May 2023 14:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240659AbjELMGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 08:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240396AbjELMF7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 08:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59BD1BC6
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 05:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683893110;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YZZfMem2ysqUiMSPrUlJfKM8LEL1qy4WhRc+FosBGoQ=;
        b=gE45Xnfy/OYS93wMCFSRloGszqwTT8IigPnkIL6JFGwkt+lnLNFd7sVK0LGS8A276B0/dY
        8onabKLeMhzY1zbBBwCeekWqxmlq0RhAcsWoMEdgEj8KbohYYLujFCQ+TVPCY/74L5Onha
        CJyA86woqxNrdzFUgQCq7m75J6yOcbo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-XApokhdlOTeUdkNGx127PA-1; Fri, 12 May 2023 08:04:10 -0400
X-MC-Unique: XApokhdlOTeUdkNGx127PA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f4dd7f13d0so12085065e9.3
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 05:04:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683893049; x=1686485049;
        h=content-transfer-encoding:mime-version:message-id:date:reply-to
         :user-agent:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YZZfMem2ysqUiMSPrUlJfKM8LEL1qy4WhRc+FosBGoQ=;
        b=IwApMbJPblmDpTke05MnDzXEDc+R/5Qjdg/04/d3YJrJjlFTJysCRgcdsd1T1Gr74n
         pYwk/KNmTSowLXXY4HDUpxjcWMgiZffPxK0241myceW0AUl9Sixf0EHpi53CdHbpgI/A
         7Cl9WOUlP5dXHjGQIUISP6I2UfR/t5QjhaBk+NiDM5XOGKhdwZDWVxysKOKqcIIf4UOT
         eOTuA3mvvO1Fgrxtb3A3CQw3d9/ddjHX67NdRhp84H8G3K9tfjdWxlDCO3Kb1RLMWRFr
         hTsQ0L/6iJVw54ZovHXNhaG6+hXgNJxpni0e96cGWihmWlURGlOJkFInavjSbZg3zAdr
         vFrg==
X-Gm-Message-State: AC+VfDyVWFe9MwacEB6UUTSOPAC1pmCl/Uyt+Vv3zb49/k4YpiXM29fD
        h+pLQbOsDYCb/G/w1F3F75ZEJf/+uu+ltUC/MXYL0WJrkA7vaW0EbiFF4kSF/31Vk8tjMW8Ph1t
        HdumSHK8StvI0
X-Received: by 2002:a5d:688a:0:b0:306:2b53:e7de with SMTP id h10-20020a5d688a000000b003062b53e7demr16107089wru.28.1683893049196;
        Fri, 12 May 2023 05:04:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+avnUQlIFEgS/+jEFMcDNUxfrm/0UJlaJkSZyFoAXywHN8UBDPObzI4rlkHA2LNqNqa9F8Q==
X-Received: by 2002:a5d:688a:0:b0:306:2b53:e7de with SMTP id h10-20020a5d688a000000b003062b53e7demr16107066wru.28.1683893048822;
        Fri, 12 May 2023 05:04:08 -0700 (PDT)
Received: from redhat.com (static-92-120-85-188.ipcom.comunitel.net. [188.85.120.92])
        by smtp.gmail.com with ESMTPSA id n2-20020a5d4c42000000b003063db8f45bsm23087904wrt.23.2023.05.12.05.04.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 05:04:08 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     Bernhard Beschow <shentey@gmail.com>
Cc:     afaerber@suse.de, ale@rev.ng, anjo@rev.ng, bazulay@redhat.com,
        bbauman@redhat.com, chao.p.peng@linux.intel.com, cjia@nvidia.com,
        cw@f00f.org, david.edmondson@oracle.com,
        dustin.kirkland@canonical.com, eblake@redhat.com,
        edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
        eric.auger@redhat.com, f4bug@amsat.org,
        Felipe Franciosi <felipe.franciosi@nutanix.com>,
        "iggy@theiggy.com" <iggy@kws1.com>, Warner Losh <wlosh@bsdimp.com>,
        jan.kiszka@web.de, jgg@nvidia.com, jidong.xiao@gmail.com,
        jjherne@linux.vnet.ibm.com, joao.m.martins@oracle.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        mburton@qti.qualcomm.com, mdean@redhat.com,
        mimu@linux.vnet.ibm.com, peter.maydell@linaro.org,
        qemu-devel@nongnu.org, richard.henderson@linaro.org,
        shameerali.kolothum.thodi@huawei.com, stefanha@gmail.com,
        wei.w.wang@intel.com, z.huo@139.com, zwu.kernel@gmail.com
Subject: Re: QEMU developers fortnightly call for agenda for 2023-05-16
In-Reply-To: <452B32A5-8C9E-4A61-B14B-C8AB47D0A3ED@gmail.com> (Bernhard
        Beschow's message of "Fri, 12 May 2023 11:41:33 +0000")
References: <calendar-f9e06ce0-8972-4775-9a3d-7269ec566398@google.com>
        <871qjm3su8.fsf@secure.mitica>
        <452B32A5-8C9E-4A61-B14B-C8AB47D0A3ED@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Fri, 12 May 2023 14:04:07 +0200
Message-ID: <87mt293geg.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bernhard Beschow <shentey@gmail.com> wrote:
> Am 12. Mai 2023 07:35:27 UTC schrieb Juan Quintela <quintela@redhat.com>:
>>juan.quintela@gmail.com wrote:
>>> Hi If you are interested in any topic, please let me know. Later, Juan.
>>
>>Hi folks
>>
>>So far what we have in the agenda is:
>>
>>questions from Mark:
>>- Update on single binary?
>>- What=E2=80=99s the status on the =E2=80=9Cicount=E2=80=9D plugin ?
>>- Also I could do with some help on a specific issue on KVM/HVF memory ha=
ndling
>>
>>From me:
>>- Small update on what is going on with all the migration changes
>>
>>Later, Juan.
>>
>>
>>> QEMU developers fortnightly conference call
>>> Tuesday 2023-05-16 =E2=8B=85 15:00 =E2=80=93 16:00
>>> Central European Time - Madrid
>>>
>>> Location
>>> https://meet.jit.si/kvmcallmeeting=09
>
> Hi Juan,
>
> Would it be possible to offer a public calendar entry -- perhaps in
> .ics format -- with above information? Which can be conveniently
> subscribed to via a smartphone app? Which gets updated regularly under
> the same link? Which doesn't (needlessly, anyway) require
> authentcation?

This is enough?

https://calendar.google.com/calendar/event?action=3DTEMPLATE&tmeid=3DNWR0NW=
ppODdqNXFyYzAwbzYza3RxN2dob3VfMjAyMzA1MTZUMTMwMDAwWiBlZ2VkN2NraTA1bG11MXRuZ=
3ZrbDN0aGlkc0Bn&tmsrc=3Deged7cki05lmu1tngvkl3thids%40group.calendar.google.=
com&scp=3DALL

If that is not enough, if you know the knob to convince google calendar
to do it I am all ears.

Later, Juan.

