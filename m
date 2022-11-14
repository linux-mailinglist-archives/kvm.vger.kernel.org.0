Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F56062829B
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 15:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237069AbiKNOcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 09:32:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237036AbiKNOcR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 09:32:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0167A29CBA
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 06:31:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668436277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9PXefMgtVoEl7VcEmHANn7C0ZpCW9EApgvQNsheadjY=;
        b=F3wjScH8ZDqll0GJl/4esBepeUJM3Bq7KS+eZzWJDUDvQygSeaGJoupx38sgEQyygRIJn9
        nP6D+YoWN9G7BFvyhHKO2+4QTeqY3L1iTe53ucacz4pOvbUeqF+y1nQCDFdcgLFLkSDspP
        8yYojy+ni8Um1C4O8iGUGhh5PzPkbYA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-325-YleM8Iq0PKWQsRedVjOBxg-1; Mon, 14 Nov 2022 09:31:15 -0500
X-MC-Unique: YleM8Iq0PKWQsRedVjOBxg-1
Received: by mail-wm1-f69.google.com with SMTP id az40-20020a05600c602800b003cfa26c40easo6315255wmb.1
        for <kvm@vger.kernel.org>; Mon, 14 Nov 2022 06:31:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9PXefMgtVoEl7VcEmHANn7C0ZpCW9EApgvQNsheadjY=;
        b=vx/23J8IQ6w0PfiG5KNINg4Nww7W/TAsPkM0YWVc4tgFQ5pNUwqXN1DBQMStM/X2r2
         VpzlEQtSjmiM/LS6HnIbl+66Bq5qYetBsWODInu+RphP98/7mfYsQnSVnY4XmpyySR5A
         tJdC/BN08BBUwXWDsOZo7SIkEdxpDX+QfzN4NuzJ6y6P31bZAVyOL+RXEaNUYKrDWjwd
         i9Yo1oOHe+/YguFn1kIk0xdEjSXoYn6mp7u3ndumpyGAPHD3H9Zw6ZAh7QLGJQTrhRZK
         XJOA8aJyZDCQE7NNgpBGH0fhFGxVGTyap5+udhn2czeT2yojMjHOECyP3d+ykuZL8JXc
         rXkw==
X-Gm-Message-State: ANoB5pnC+uCqnqNsoCF0qq7TmA9kLa0Fe/+1QbwALSJqtSB963f5WeHD
        EEVKU836MXwNx+Q73RTucpNlLHt0bjjRwrQ0TRFAlsbZqWx1ShdjbfKWclfi2CH7/m0xPLrlfvP
        uuOjWZOn//n7R
X-Received: by 2002:a5d:68c9:0:b0:22e:35f4:9182 with SMTP id p9-20020a5d68c9000000b0022e35f49182mr7429038wrw.121.1668436274573;
        Mon, 14 Nov 2022 06:31:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6YLO6tG7/e8aZUItVpRGpp6PUXS3yORBpjb+RdGBuPkzuHvOVmJbAq7k0iXg4QkhH4ns473Q==
X-Received: by 2002:a5d:68c9:0:b0:22e:35f4:9182 with SMTP id p9-20020a5d68c9000000b0022e35f49182mr7429029wrw.121.1668436274382;
        Mon, 14 Nov 2022 06:31:14 -0800 (PST)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id f4-20020adff984000000b0024194bba380sm1530129wrr.22.2022.11.14.06.31.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 06:31:13 -0800 (PST)
Message-ID: <869d05b2ce0437efae1cf505cf4028ceb4920ce2.camel@redhat.com>
Subject: Re: [PATCHv5 0/8] Virtual NMI feature
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Santosh Shukla <santosh.shukla@amd.com>, pbonzini@redhat.com,
        seanjc@google.com, jmattson@google.com
Cc:     kvm@vger.kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, thomas.lendacky@amd.com,
        vkuznets@redhat.com
Date:   Mon, 14 Nov 2022 16:31:12 +0200
In-Reply-To: <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
References: <20221027083831.2985-1-santosh.shukla@amd.com>
         <d109feb8-7d07-0bf1-f4ad-76d4230ed498@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-11-14 at 13:32 +0530, Santosh Shukla wrote:
> 
> 
> On 10/27/2022 2:08 PM, Santosh Shukla wrote:
> > VNMI Spec is at [1].
> > 
> > Change History:
> > 
> > v5 (6.1-rc2)
> > 01,02,06 - Renamed s/X86_FEATURE_V_NMI/X86_FEATURE_AMD_VNMI (Jim Mattson)
> > 
> 
> Gentle reminder.
> 
> Thanks,
> Santosh
> 

I started reviewing it today and I think there are still few issues,
and the biggest one is that if a NMI arrives while vNMI injection
is pending, current code just drops such NMI.

We had a discussion about this, like forcing immeditate vm exit
in this case and such but I have a simplier idea:

In this case we can just open the NMI window in the good old way
by intercepting IRET, STGI, and or RSM (which is intercepted anyway),

and only if we already *just* intercepted IRET, only then just drop 
the new NMI instead of single stepping over it based on reasoning that
its 3rd NMI (one is almost done the servicing (its IRET is executing),
one is pending injection, and we want to inject another one.

Does this sound good to you? It won't work for SEV-ES as it looks
like it doesn't intercept IRET, but it might be a reasonable tradeof
for SEV-ES guests to accept that we can't inject a NMI if one is
already pending injection.

Best regards,
	Maxim Levitsky

