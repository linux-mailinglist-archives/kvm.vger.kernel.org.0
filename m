Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29DB7429F4
	for <lists+kvm@lfdr.de>; Thu, 29 Jun 2023 17:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjF2Pyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jun 2023 11:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjF2Pyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Jun 2023 11:54:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23BF10FB;
        Thu, 29 Jun 2023 08:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CC226153C;
        Thu, 29 Jun 2023 15:54:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28680C433C8;
        Thu, 29 Jun 2023 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688054078;
        bh=L6FQS4d7vn+9QEms0SfAm1VLkLjV+bIazDI0tjMBu5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=k8QvCfS9YYp1B+ART94SdyS5GCq+kzg+y0GcPPcxH+Mz9b1I4fFjWlHyii0LCx/Zb
         6oqHcWtiuE3GTIm5ZtGtpI5GJoj+Uki8akhd/tLN8XIvFLJ4vCNRMSzWFjh3vcU96P
         F6nnnWDIE4ZC6jcq+iQOB7KR1kmI5HAuZgfRETPIGLrJefP/K7dQk2FX6jv6Do9o62
         6dFS9sWsPtWknyZX4osw36zBl8rdJv7ce0BtqwOjDubXmJlfxwaLWPMCaZA0PiKewB
         /QBRqLcnYPOwgUGemUscA0GTUkIR0SFl9qk65pBR8RcIQJ0ANd+rxatzb7VXpj8G2x
         dcnTEBewzlWmg==
Date:   Thu, 29 Jun 2023 10:54:36 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Sui Jingfeng <suijingfeng@loongson.cn>
Cc:     Sui Jingfeng <15330273260@189.cn>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-fbdev@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        nouveau@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        dri-devel@lists.freedesktop.org, YiPeng Chai <YiPeng.Chai@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        David Airlie <airlied@gmail.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, kvm@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, Jason Gunthorpe <jgg@ziepe.ca>,
        Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        intel-gfx@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Maxime Ripard <mripard@kernel.org>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>
Subject: Re: [PATCH v7 6/8] PCI/VGA: Introduce is_boot_device function
 callback to vga_client_register
Message-ID: <20230629155436.GA397963@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0dd961ae-78a7-0b67-af51-008ecbcdbbef@loongson.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 22, 2023 at 01:08:15PM +0800, Sui Jingfeng wrote:
> Hi,
> 
> 
> A nouveau developer(Lyude) from redhat send me a R-B,
> 
> Thanks for the developers of nouveau project.
> 
> 
> Please allow me add a link[1] here.
> 
> 
> [1] https://lore.kernel.org/all/0afadc69f99a36bc9d03ecf54ff25859dbc10e28.camel@redhat.com/

1) Thanks for this.  If you post another version of this series,
   please pick up Lyude's Reviewed-by and include it in the relevant
   patches (as long as you haven't made significant changes to the
   code Lyude reviewed).  Whoever applies this should automatically
   pick up Reviewed-by/Ack/etc that are replies to the version being
   applied, but they won't go through previous revisions to find them.

2) Please mention the commit to which the series applies.  I tried to
   apply this on v6.4-rc1, but it doesn't apply cleanly.

3) Thanks for including cover letters in your postings.  Please
   include a little changelog in the cover letter so we know what
   changed between v6 and v7, etc.

4) Right now we're in the middle of the v6.5 merge window, so new
   content, e.g., this series, is too late for v6.5.  Most
   maintainers, including me, wait to merge new content until the
   merge window closes and a new -rc1 is tagged.  This merge window
   should close on July 9, and people will start merging content for
   v6.6, typically based on v6.5-rc1.

Bjorn
