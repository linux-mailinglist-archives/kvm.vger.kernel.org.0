Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAE6A3E0148
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 14:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbhHDMiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 08:38:51 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35072 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbhHDMiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 08:38:50 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9DBD91FDE1;
        Wed,  4 Aug 2021 12:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628080717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2f91k6SgHUkmkVOGvL33AmKyXMuC7A2FSqIjj4I2NVk=;
        b=1A8WFnuOFzhWbZIyx4BDTQUrN2cu6PhZbtMp/QThM+7uujODcjMhmKfSuloyDHt2BkCFGI
        Km4+sMgFUtDAycRSAyTuf5vHka24OKn0+YtPjH2RLvir1T1sMc797Xvx8WETYLFUNMf2Zl
        I4guBTLbMS9g7EV15SZaxAkbl9+KEUE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628080717;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2f91k6SgHUkmkVOGvL33AmKyXMuC7A2FSqIjj4I2NVk=;
        b=I2AINXixJWDiDqNI6pb+XuVbrlEEbRW8ruYNojo+PLCc3gRod+DTbvQfGHN1/vnGQM2E2E
        6hsSo9QLBU+IB8Ag==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 7C8FE13672;
        Wed,  4 Aug 2021 12:38:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id D2KiHE2KCmGsLQAAGKfGzw
        (envelope-from <jroedel@suse.de>); Wed, 04 Aug 2021 12:38:37 +0000
Date:   Wed, 4 Aug 2021 14:38:35 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [bug report] x86/sev: Split up runtime #VC handler for correct
 state tracking
Message-ID: <YQqKS7ayK1qkmNzv@suse.de>
References: <20210804095725.GA8011@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804095725.GA8011@kili>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Dan,

On Wed, Aug 04, 2021 at 12:57:25PM +0300, Dan Carpenter wrote:
> These sleeping in atomic static checker warnings come with a lot of
> caveats because the call tree is very long and it's easy to have false
> positives.
> 
> --> vc_raw_handle_exception()
>     --> vc_forward_exception()
>         --> exc_page_fault()
> 
> Page faults always sleep right?

No, page faults do no always sleep, only when IO needs to be done to
fulfill the page fault request. In this case, the page-fault handler
will never sleep, because it is called with preemption disabled. The
page-fault handler can detect this and just do nothing. The #VC handler
will return for re-fault in this case.

Hope that helps,

     Joerg

