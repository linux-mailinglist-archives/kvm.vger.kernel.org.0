Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6FA64F8FBE
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 09:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiDHHpP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 03:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiDHHpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 03:45:12 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5216B1BD81F
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 00:43:08 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EA1131F861;
        Fri,  8 Apr 2022 07:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649403786; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D91alDKSn8qy+HiNCVZ8jqxTZlepaU7yaFo6qWRLmOo=;
        b=pjZ18QawhJMhp713tkXCF6jT+AMak8pthyVJ7Am3dNJldd5YKaKLxyyHEgOiN8gTpNS6R7
        pkDfnromsmCca11wM45IkSX3sxXQOtOe8WoIntyv7UcsX2W0aTcY5iXA20phHXb+lObAlD
        1YAeXljv1eAFvf3LZ6V9mbkUkdJC4Xk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649403786;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D91alDKSn8qy+HiNCVZ8jqxTZlepaU7yaFo6qWRLmOo=;
        b=fXeV/RwzOvny5MXgeHylF13ThHdSNgviI5Sr+pd4AikiZrh243dPXVzvPXud7IBVs0Thb+
        zaZ/qTfzspmbj8CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8889013AA9;
        Fri,  8 Apr 2022 07:43:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DzKXH4rnT2LvFwAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 08 Apr 2022 07:43:06 +0000
Date:   Fri, 8 Apr 2022 09:43:05 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: AMD SEV-ES: Handle string
 IO for IOIO #VC
Message-ID: <Yk/nid+BndbMBYCx@suse.de>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-12-varad.gautam@suse.com>
 <Ykzx5f9HucC7ss2i@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ykzx5f9HucC7ss2i@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06, 2022 at 01:50:29AM +0000, Sean Christopherson wrote:
> On Thu, Feb 24, 2022, Varad Gautam wrote:
> > Using Linux's IOIO #VC processing logic.
> 
> How much string I/O is there in KUT?  I assume it's rare, i.e. avoiding it entirely
> is probably less work in the long run.

The problem is that SEV-ES support will silently break if someone adds
it unnoticed and without testing changes on SEV-ES.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

