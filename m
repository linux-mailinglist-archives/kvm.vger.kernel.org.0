Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2795E2DC465
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 17:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgLPQiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 11:38:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgLPQiN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 16 Dec 2020 11:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608136607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vs7gwDTNiuwyvUIyecGawTbsNjvRWskX1WlIMx8cvWU=;
        b=IOoe6aFmEIxdXuL/c9RJs5iaNRiG43MiXogzcriE/BKy5ZH5bKlOSrAFFIKoJ7NygaT+hK
        MxKzZItPaPSJEIrLlOARtmEnYZnQsRtp/ID9ZuOM2iE5tuJaGz0PrTxIruODWpC7Gv35TI
        +3wXzTDnCSGbsdZynoa7UIKEnaL4a+g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-610QQ1eFNniERGSAVVuv9w-1; Wed, 16 Dec 2020 11:36:44 -0500
X-MC-Unique: 610QQ1eFNniERGSAVVuv9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFA2F8B7E7C;
        Wed, 16 Dec 2020 16:36:15 +0000 (UTC)
Received: from treble (ovpn-112-170.rdu2.redhat.com [10.10.112.170])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F26B3100AE3E;
        Wed, 16 Dec 2020 16:36:14 +0000 (UTC)
Date:   Wed, 16 Dec 2020 10:36:13 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Dexuan Cui <decui@microsoft.com>, Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, ardb@kernel.org
Subject: Re: [PATCH] jump_label: Fix usage in module __init
Message-ID: <20201216163613.nyrd25vakui2tdiy@treble>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
 <20201216105926.GS3092@hirez.programming.kicks-ass.net>
 <20201216135435.GV3092@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201216135435.GV3092@hirez.programming.kicks-ass.net>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 02:54:35PM +0100, Peter Zijlstra wrote:
> Subject: jump_label: Fix usage in module __init
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Dec 16 12:21:36 CET 2020
> 
> When the static_key is part of the module, and the module calls
> static_key_inc/enable() from it's __init section *AND* has a
> static_branch_*() user in that very same __init section, things go
> wobbly.
> 
> If the static_key lives outside the module, jump_label_add_module()
> would append this module's sites to the key and jump_label_update()
> would take the static_key_linked() branch and all would be fine.
> 
> If all the sites are outside of __init, then everything will be fine
> too.
> 
> However, when all is aligned just as described above,
> jump_label_update() calls __jump_label_update(.init = false) and we'll
> not update sites in __init text.
> 
> Fixes: 19483677684b ("jump_label: Annotate entries that operate on __init code earlier")
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Tested-by: Jessica Yu <jeyu@kernel.org>

Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>

-- 
Josh

