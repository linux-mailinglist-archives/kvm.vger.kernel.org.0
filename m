Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36EFF565510
	for <lists+kvm@lfdr.de>; Mon,  4 Jul 2022 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234492AbiGDMWs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jul 2022 08:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234373AbiGDMWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jul 2022 08:22:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C61BB124
        for <kvm@vger.kernel.org>; Mon,  4 Jul 2022 05:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656937356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWz4hoF8KR1Xh3Y20DcZ/pecKJBOXaX2hZBdX2dWxEY=;
        b=aaY3nUXBQJ/fUppi0Tn7UnvTloVx5Tc9p03HSPGSsHj4XbAxE9vgU2UBo5h0GykdteHrF/
        OJRMUnFobNmdVH2AjcnrTc2/U0twbA2MGGxdWDXDb+ZcVw7/VX+ExxsYA12Xj+czaN8VQ5
        3gfu1K5HYyeVCL4ebO99WwAgvEfZK0M=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-YPox5Gz8PUGC1AVDzcRQvw-1; Mon, 04 Jul 2022 08:22:35 -0400
X-MC-Unique: YPox5Gz8PUGC1AVDzcRQvw-1
Received: by mail-wm1-f69.google.com with SMTP id bg6-20020a05600c3c8600b003a03d5d19e4so5279167wmb.1
        for <kvm@vger.kernel.org>; Mon, 04 Jul 2022 05:22:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NWz4hoF8KR1Xh3Y20DcZ/pecKJBOXaX2hZBdX2dWxEY=;
        b=kTz+rw9/pQIEGWtI+Rk0kGO+FBuWBqEHAUYMuq++TJrts28jIVKL9t3fdMFMz+uvhy
         9oAlUNSFkf1XFyW6srYKqnD0PuCSZsspcpMqU4ByhQC3UwZRG6IMMvVnQ+YBPuhlZaZn
         YnwwNLcm1GrPDbmOF3ozmxoyEqIqjIjhsIdVN0QwkVyc4gCo9ZQZigJsSEh/4zUo1AtL
         a+NbHsA+sUowj+cZIKBAY+PnB6PFb1BYeJq/3YEaQ/OPPfX2AkfhQMW4CjLdIGD9bDnC
         2OWT7TMQitmSRdHutyWVpr169uevRgHYaQIgtJXFeYjn0bglCDxG2lEPEnx5TovDsZZ0
         Yrew==
X-Gm-Message-State: AJIora/oRGMHGb+gBgrqDLZ5DRVKdr9WFj6PGsow0XG6Yldp2hzUOOcw
        uSDKTok5EmRL9u10ttdy0a6319c4BmWMtFB3URkcSws7oVlEatkOflBfKCH9PPU4NqkUMvVENiB
        KwprGFj8iOPkW
X-Received: by 2002:a05:6000:184f:b0:21c:ae47:9b45 with SMTP id c15-20020a056000184f00b0021cae479b45mr29036167wri.76.1656937354541;
        Mon, 04 Jul 2022 05:22:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t+u2tPZeiBujJigb3uaJA2WHPeBf3YiC6XaaM/lLav9FDHwk1h6zTOaQcjNHZhn8GP9Wpmog==
X-Received: by 2002:a05:6000:184f:b0:21c:ae47:9b45 with SMTP id c15-20020a056000184f00b0021cae479b45mr29036127wri.76.1656937354201;
        Mon, 04 Jul 2022 05:22:34 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id l2-20020a05600c2cc200b003a18e7a5af2sm12420591wmc.34.2022.07.04.05.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jul 2022 05:22:33 -0700 (PDT)
Message-ID: <0425d2f4-a859-46c7-b184-e32efe7165a2@redhat.com>
Date:   Mon, 4 Jul 2022 14:22:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v6 3/5] fbdev: Disable sysfb device registration when
 removing conflicting FBs
Content-Language: en-US
To:     Xi Ruoyao <xry111@linuxfromscratch.org>,
        Zack Rusin <zackr@vmware.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "deller@gmx.de" <deller@gmx.de>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Linux-graphics-maintainer <Linux-graphics-maintainer@vmware.com>,
        "kraxel@redhat.com" <kraxel@redhat.com>,
        "tzimmermann@suse.de" <tzimmermann@suse.de>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "lersek@redhat.com" <lersek@redhat.com>
References: <20220607182338.344270-1-javierm@redhat.com>
 <20220607182338.344270-4-javierm@redhat.com>
 <de83ae8cb6de7ee7c88aa2121513e91bb0a74608.camel@vmware.com>
 <38473dcd-0666-67b9-28bd-afa2d0ce434a@redhat.com>
 <603e3613b9b8ff7815b63f294510d417b5b12937.camel@vmware.com>
 <a633d605-4cb3-2e04-1818-85892cf6f7b0@redhat.com>
 <97565fb5-cf7f-5991-6fb3-db96fe239ee8@redhat.com>
 <711c88299ef41afd8556132b7c1dcb75ee7e6117.camel@vmware.com>
 <aa144e20-a555-5c30-4796-09713c12ab0e@redhat.com>
 <64c753c98488a64b470009e45769ceab29fd8130.camel@linuxfromscratch.org>
 <61f2e4e2af40cb9d853504d0a6fe01829ff8ca60.camel@linuxfromscratch.org>
 <fddf5ca6-77dc-88f9-c191-7de09717063c@redhat.com>
 <2ae767b0439133ca4e60885a1843ee72b69adfc5.camel@linuxfromscratch.org>
From:   Javier Martinez Canillas <javierm@redhat.com>
In-Reply-To: <2ae767b0439133ca4e60885a1843ee72b69adfc5.camel@linuxfromscratch.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/4/22 14:11, Xi Ruoyao wrote:
> On Mon, 2022-07-04 at 13:04 +0200, Javier Martinez Canillas wrote:
>> Hello Xi,
>>>
>>> With CONFIG_SYSFB_SIMPLEFB and CONFIG_FB_SIMPLE enabled, there is no
>>> issue.
>>>
>>> I guess it's something going wrong on a "drm -> drm" pass over.  For now
>>> I'll continue to use simpledrm with this commit reverted.
>>>
>>
>> Yes, we need to also cherry-pick b84efa28a48 ("drm/aperture: Run fbdev
>> removal before internal helpers") now that the sysfb_disable() patches
>> are in v5.19-rc5.
> 
> I confirm that cherry-picking b84efa28a48 fixes the issue for v5.19-rc5.
> 

Thanks for testing it! Thomas is getting that patch through the drm-fixes
path, so it should make it to the v5.19-rc cycle at some point.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

