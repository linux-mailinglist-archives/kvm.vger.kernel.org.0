Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77F5168701C
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbjBAUtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:49:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbjBAUsx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:48:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8A184188
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:46:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675284395;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=UhoW1Rl89YyqefCw19L7KsTDj/dagdWKUA9x2Lip+JE=;
        b=ZMPXDgXLfN3cbVsxo4q9SaKx5aLs4wR547fYdLpQHM2R1S8doTJJl5PneN220ziTIbQsQ2
        fmXkGRUVj+t1NdOh8eXKPYfJQ97KG6KDVMgCc9CA8prNDO2JvRrHSJHpAg8C4+MPl8B+Of
        yfyg5LqnRN3lVlR5gJcCMkEfAT2X8g4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-379-3Hk9LCkNPQC5pDGMGqFGyA-1; Wed, 01 Feb 2023 15:46:34 -0500
X-MC-Unique: 3Hk9LCkNPQC5pDGMGqFGyA-1
Received: by mail-wm1-f70.google.com with SMTP id iv6-20020a05600c548600b003dc4b8ee42fso7338658wmb.1
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:46:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:reply-to:user-agent:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UhoW1Rl89YyqefCw19L7KsTDj/dagdWKUA9x2Lip+JE=;
        b=2epupaGqPYjVzso9ER/Njt4oJDDk1lcdxEw17sqMmGuOclClJ735plmBleNaB51OT9
         rCpniusM68gDDM5eu82/JA5oVLxyoyN0actOwFqdeuw/zirO09sQZhqmJlfPkU4b4cWi
         jVD0Yp6MNnk+ZxKhdBdgEIRjQdRBgXagEtiEI522pVXJp9YZn3HckIgLqcX7ylAUFzEW
         01/GWtt6TPu0jqWl2BA60JMwuYXl41nMhFv9OoDyTqk+DmWV9lqTpIWoDYtxXpp3FdCO
         0yz1LoauPNN7YyA7NUzEqN043ybO15L5OT2Yg4ufSEntiYdBBcGXDQAh9/Cbq9bNPA1h
         FEFw==
X-Gm-Message-State: AO0yUKW7ecjZ8+abKk8PMV6+TgQtwzm+qVF5JwLS7MJn6xkZMirsytzL
        4cqdZqwYxZast9Sz+H2ru6L0O4UA/sUTm6pJnIbgO6uX6PeYI3ZwYpVMD5dotxroZAX4peZrBbH
        SH6KH8Jb+tZkJ
X-Received: by 2002:a05:600c:3ac8:b0:3da:1d52:26b5 with SMTP id d8-20020a05600c3ac800b003da1d5226b5mr160964wms.14.1675284392928;
        Wed, 01 Feb 2023 12:46:32 -0800 (PST)
X-Google-Smtp-Source: AK7set8KE6Wl8pVL+8nJm5g0goJ6ktEsdxHOwtd5L4rmH+fGs7l7dnq47KLa3+PlYSLKTlDf7RtgMA==
X-Received: by 2002:a05:600c:3ac8:b0:3da:1d52:26b5 with SMTP id d8-20020a05600c3ac800b003da1d5226b5mr160958wms.14.1675284392697;
        Wed, 01 Feb 2023 12:46:32 -0800 (PST)
Received: from redhat.com ([46.136.252.173])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c4fc900b003dc1300eab0sm3128663wmq.33.2023.02.01.12.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:46:32 -0800 (PST)
From:   Juan Quintela <quintela@redhat.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     qemu-devel@nongnu.org, pbonzini@redhat.com, kraxel@redhat.com,
        kwolf@redhat.com, hreitz@redhat.com, marcandre.lureau@redhat.com,
        dgilbert@redhat.com, mst@redhat.com, imammedo@redhat.com,
        ani@anisinha.ca, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        philmd@linaro.org, wangyanan55@huawei.com, jasowang@redhat.com,
        jiri@resnulli.us, berrange@redhat.com, thuth@redhat.com,
        stefanb@linux.vnet.ibm.com, stefanha@redhat.com,
        kvm@vger.kernel.org, qemu-block@nongnu.org
Subject: Re: [PATCH 18/32] migration: Move the QMP command from monitor/ to
 migration/
In-Reply-To: <20230124121946.1139465-19-armbru@redhat.com> (Markus
        Armbruster's message of "Tue, 24 Jan 2023 13:19:32 +0100")
References: <20230124121946.1139465-1-armbru@redhat.com>
        <20230124121946.1139465-19-armbru@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
Reply-To: quintela@redhat.com
Date:   Wed, 01 Feb 2023 21:46:31 +0100
Message-ID: <87pmatuna0.fsf@secure.mitica>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Markus Armbruster <armbru@redhat.com> wrote:
> This moves the command from MAINTAINERS sections "Human Monitor (HMP)"
> and "QMP" to "Migration".
>
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Juan Quintela <quintela@redhat.com>

