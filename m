Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2A7768484
	for <lists+kvm@lfdr.de>; Sun, 30 Jul 2023 10:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjG3Izq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jul 2023 04:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjG3Izp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jul 2023 04:55:45 -0400
Received: from mailrelay4-1.pub.mailoutpod2-cph3.one.com (mailrelay4-1.pub.mailoutpod2-cph3.one.com [IPv6:2a02:2350:5:403::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1D4A9
        for <kvm@vger.kernel.org>; Sun, 30 Jul 2023 01:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=mFakZeALJNGvZSohmf/wWFUZxBT4BMrnbpl3ezu/8xg=;
        b=BU2t5HBt6AxOY9DWmwd6uVqDKEE6+EORAWwGLRuq4UorA+nAmmNoiWomF9qfvGspOvbS5ZvS18F1t
         sk62CSt8rHuLirMkNIcpKQKLW7KrCzbBDjjwykcMa8eZYeSzO/wWRhEl4ModKf6VdkdQ6HCO+OufGP
         ZQv1d1Ee75zSjQdI2Y3Vhu2MskkhjLvfmey4l70qsJZ1sw2yDfEA6inc15z6WgcmYapS8KN56uoTTq
         SW+OgaZgrWr0daiw5leZG4aHgHGTzRnYv2HkRLTyTJx68fTSbKyyW03gzmi6+T3qJb1begPp9VdUKt
         Z4Pvdt0SX24tWwnnDBMxh5Iu9oHsmZw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=mFakZeALJNGvZSohmf/wWFUZxBT4BMrnbpl3ezu/8xg=;
        b=PuqQNp88Cg2L0KD+9U1TyBW/+zsbjIekPa25mUj+6EtxjJ32lV2tqPeMPZhXBf85jc+srwd8PN3mi
         ADw66rFCA==
X-HalOne-ID: dbd268c0-2eb6-11ee-a19a-592bb1efe9dc
Received: from ravnborg.org (2-105-2-98-cable.dk.customer.tdc.net [2.105.2.98])
        by mailrelay4 (Halon) with ESMTPSA
        id dbd268c0-2eb6-11ee-a19a-592bb1efe9dc;
        Sun, 30 Jul 2023 08:55:41 +0000 (UTC)
Date:   Sun, 30 Jul 2023 10:55:40 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Thomas Zimmermann <tzimmermann@suse.de>
Cc:     linux-fbdev@vger.kernel.org, kvm@vger.kernel.org, deller@gmx.de,
        javierm@redhat.com, dri-devel@lists.freedesktop.org,
        linux-geode@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 00/47] fbdev: Use I/O helpers
Message-ID: <20230730085540.GB1322260@ravnborg.org>
References: <20230728182234.10680-1-tzimmermann@suse.de>
 <20230728183541.GA1144760@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728183541.GA1144760@ravnborg.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 08:35:41PM +0200, Sam Ravnborg wrote:
> Hi Thomas,
> 
> On Fri, Jul 28, 2023 at 06:39:43PM +0200, Thomas Zimmermann wrote:
> > Most fbdev drivers operate on I/O memory. And most of those use the
> > default implementations for file I/O and console drawing. Convert all
> > these low-hanging fruits to the fb_ops initializer macro and Kconfig
> > token for fbdev I/O helpers.
> > 
> > The fbdev I/O helpers are easily grep-able. In a later patch, they can
> > be left to empty values if the rsp. funtionality, such as file I/O or
> > console, has been disabled.
> > 
> > There are no functional changes. The helpers set the defaults that
> > the drivers already use.
> 
> I have browsed all patches - they all looks good.
> Reviewed-by: Sam Ravnborg <sam@ravnborg.org>

When you post v2 with MEM added the review still holds true.

	Sam
