Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4A93E0301
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 16:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhHDOXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 10:23:49 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:56732 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbhHDOXl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 10:23:41 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E355722227;
        Wed,  4 Aug 2021 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628087007; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3lgA3gR5Pxpz3rMev4OlYzcQXEjYQJEKFrjml4j8SQ=;
        b=TuPo6t0p+3Y9vKhnAM2SaS9RReH7LeDTtdIG8wadHPJb9exI6LKaxeXVRssrkJcSi9Z6ee
        QTQhZTMuC0IF15YIcZpbJKF9sUyocUji1z2cTU3poANxQZM2Y7hKW1R9SUdnOLHhF/37t5
        z1hrNgpS0zuCowyfPvBndLyMLUyf4RQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628087007;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3lgA3gR5Pxpz3rMev4OlYzcQXEjYQJEKFrjml4j8SQ=;
        b=MlZJrGA3zawB4RmAlKYtKK7rY5Q2N9Osnq2A5Zyu2kecip2CS9st6yHgvrmRQsB7fGeFU5
        NoSotCRb28Co9BBg==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id BBA7A13BD0;
        Wed,  4 Aug 2021 14:23:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id dUFoK9+iCmGNTgAAGKfGzw
        (envelope-from <jroedel@suse.de>); Wed, 04 Aug 2021 14:23:27 +0000
Date:   Wed, 4 Aug 2021 16:23:26 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <YQqi3lKFmR7g/kIl@suse.de>
References: <20210804095725.GA8011@kili>
 <YQqKS7ayK1qkmNzv@suse.de>
 <20210804125834.GF22532@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804125834.GF22532@kadam>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021 at 03:58:34PM +0300, Dan Carpenter wrote:
> exc_page_fault() <-- called with preempt disabled
> --> kvm_handle_async_pf()
>     --> __kvm_handle_async_pf()
>         --> kvm_async_pf_task_wait_schedule() calls schedule().

This call path can not be taken in the page-fault handler when called
from the #VC handler. To take this path the host needs to inject an
async page-fault, especially setting async pf flags, without injecting a
page-fault exception on its own ... and when the #VC handler is running.
KVM is not doing that.

Okay, the hypervisor can be malicious, but otherwise this can't happen.
To mitigate a malicious hypervisor threat here it might be a solution to
not call the page-fault handler directly from the #VC handler and let it
re-fault after the #VC handler returned.

Regards,

	Joerg
