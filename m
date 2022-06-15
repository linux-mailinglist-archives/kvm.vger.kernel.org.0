Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 534B354CFF0
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 19:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357557AbiFORb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 13:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357447AbiFORbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 13:31:42 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14A0532DA;
        Wed, 15 Jun 2022 10:31:01 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h23so14079947ljl.3;
        Wed, 15 Jun 2022 10:31:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S+ySF5+RLBUM3QPHi6MA3TzGhzSAurJUC+jncUgCsRc=;
        b=oMA15tbpzEdGlKiyfXb5SLd3P+xkuaKwbaM/QHA1skT8LxR0cIeYyE+94VdFZOrBB3
         6Ikdvry4cnM8jwsHnviP1lsarXOIQcE0owqpI2XFKAl52aqhcKCzcgHe6eTELD1gDB0o
         SSonCNSkaGCtOgEJewAyT1pY7SG1b8mNCKjPBnGcewbC0389z70EPNL5169MnF99U5HT
         pdU5fP33iK7nbVr2zlcXp8M003GXEagGugIjUu0VpSqd+l4T5vs353eReu4O6jFQFqv9
         2wGWVqgIyGxdxrc+KjmR3XIZf6Riqwz5O4+pmu9WskwYGnjAYpBDWYWo7FSlGrY+uH29
         MNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S+ySF5+RLBUM3QPHi6MA3TzGhzSAurJUC+jncUgCsRc=;
        b=eCw/f8SzhQXb1gjZxwILKnhDULkvrQxNcbt0EJ5SvUQ/lb573kw3oQuQSHSnFqCq+R
         ta0KNZpgN//rG9RjOlLNHiQD3RavS1+aqbzBKVOOd65etuZveUlyu3NcsYmmDtfpieSf
         i44eTVM3UnspWVpT+LdcnjEFtjW0q22eElK5ESIpCwEDQMSPkuR68z8L9UrYR2y17b5i
         +NZ/rHoD1ytv1LAsRBhD7lTHu6EWqzVj673mqnKk0EnF8LaJwHemex1uC/AL2Xj26+tU
         RxAyW5UzUaDL40ICRV2uoHQQko7MayfhcVkIB0PLwwcK9AyGHQUNbzV0+Q+GW4CFU/U5
         1QWQ==
X-Gm-Message-State: AJIora8bVs72LnUqwAuhoqHKK/wumc9CD+XeSdrn+24+oHyi/vgidEO3
        TRpN2QPVYnKEAhJK6GqTkZU=
X-Google-Smtp-Source: AGRyM1tzod6LPQAk997JRpS1iOWcP3H1iJAWIcqeANKVzdOEflRBr27A1paG4kOnj6oAwRMdGmAOCg==
X-Received: by 2002:a05:651c:1a13:b0:256:39d4:f630 with SMTP id by19-20020a05651c1a1300b0025639d4f630mr444577ljb.84.1655314260209;
        Wed, 15 Jun 2022 10:31:00 -0700 (PDT)
Received: from isaak (static.119.124.99.88.clients.your-server.de. [88.99.124.119])
        by smtp.gmail.com with ESMTPSA id bj16-20020a2eaa90000000b0025a21ff1a51sm309239ljb.79.2022.06.15.10.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 10:30:59 -0700 (PDT)
Date:   Wed, 15 Jun 2022 20:30:57 +0300
From:   Dmitry Klochkov <kdmitry556@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Raspl <raspl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH RESEND] tools/kvm_stat: fix display of error when
 multiple processes are found
Message-ID: <20220615173057.2lqjwahtfdph2qa4@isaak>
References: <20220614121141.160689-1-kdmitry556@gmail.com>
 <20220615121427.1662350-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615121427.1662350-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 08:14:27AM -0400, Paolo Bonzini wrote:
> Queued, thanks.
> 
> Paolo
> 
> 

Thank you Paolo!

Dmitry
