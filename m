Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8883A6CD70A
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjC2JzN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 05:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbjC2JzG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 05:55:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F0210E4
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 02:55:04 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ACE3B1F7AB;
        Wed, 29 Mar 2023 09:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680083703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMv8gydYZlcE85oYtkF7qR4p2GOq503MsgLQrPrdWVI=;
        b=PLwmyeSVgdrgq3W22Va8f3vYU9CHqE7/gwJeG712BS7L0xRgGxsQovvJr65YhM9B9QLmLN
        T2d3vN2ThT87RmzXGXJzmyX7ldJigKeJN9hrkbVn/msphjvKKGSeJ6QvW/tZGyZBX7cIh8
        fpc4ggvC0eQZ+/YuvqVL+hbcnVFwu64=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680083703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KMv8gydYZlcE85oYtkF7qR4p2GOq503MsgLQrPrdWVI=;
        b=FmOWfFjN0HZFQpYwRHEw9LEHY7fZuTnGdiamlcnzH2+xqnqqjOSqvVrrqFbS9kkhQfBZUD
        gj6nigsceeyS6aCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 59C2F138FF;
        Wed, 29 Mar 2023 09:55:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id l7l0FPcKJGRwFQAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 29 Mar 2023 09:55:03 +0000
Date:   Wed, 29 Mar 2023 11:55:01 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        Vasant Karasulli <vkarasulli@suse.de>
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder
 from Linux
Message-ID: <ZCQK9diBPBjl018H@suse.de>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-5-varad.gautam@suse.com>
 <YkzuvuLYjira8iOW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkzuvuLYjira8iOW@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

trying to get some tracktion here again.

On Wed, Apr 06, 2022 at 01:37:02AM +0000, Sean Christopherson wrote:
> Do we really need Linux's decoder for this?  Linux needs a more robust decoder
> because it has to deal with userspace crud, but KUT should have full control over
> what code it encounters in a #VC handler, e.g. we should never have to worry about
> ignore prefixes on a WRMSR.  And looking at future patches, KUT is still looking
> at raw opcode bytes, e.g.

I think just importing Linux' instruction decoder is the most robust
solution for kvm-unit-tests. The code does MMIO today and who knows what
the future will bring. To minimize the risk that changes unrelated to
SEV-ES will break it all the time, having a full instruction decoder is
the best option.

The maintenance cost for this should be pretty low, as the Linux code
has no dependencies and new versions can be ported over as needed with
little effort.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Frankenstraße 146
90461 Nürnberg
Germany

(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman

