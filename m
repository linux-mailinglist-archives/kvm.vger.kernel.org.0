Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF22A521E08
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345592AbiEJPWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345651AbiEJPVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:21:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B7B43EB8B
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 08:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652194864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZgUzPbN0afxln/UTR8mU8CnaJ4q6LZxgDDzZlA9fUdQ=;
        b=E7Qxe1u9nt6y4JtZLVZ6ZJgiSulF6XDKmNgpVnPtZdFVc93zZTMBosIUjQYLvYWBQ1T7GN
        lcuwoHy8LZ2KtM+NkDRMNH9jtqWgBy+mF20tnfgZvRQB+oFC0PQp5YkoKzayW7mrR7nuBA
        0VGdVpxGqYjLkUB97bO9xAIcvUUJhwc=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-SdsshyC1NcCwsp3QjjeItA-1; Tue, 10 May 2022 11:01:01 -0400
X-MC-Unique: SdsshyC1NcCwsp3QjjeItA-1
Received: by mail-io1-f72.google.com with SMTP id h17-20020a056602155100b0065aa0081429so11986905iow.10
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 08:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ZgUzPbN0afxln/UTR8mU8CnaJ4q6LZxgDDzZlA9fUdQ=;
        b=AmmxN1My/8sc1DY4pzNcFM1qAldG4ork6QMW/Xsn58he8tHivyF1bxL/26B+BljcZg
         oLvc+y9k8ipqF0n9lKia8uxBJSA8ojaWFxoISjA8A1b0LbB6sykqO5qTt/kdejKBNU6V
         bx6pOG5yybj2jsRRbabSd1IU2aR6cgtHZOX13BeW08AlHN3WFf9JBlSXJxA3Fmw+MkDn
         kpm8gtuLvUscTZnAx7MG5Or9hHuWh0DC4Aoy/Ltuxsk07sX6LZou1HQeh9KBjxaS6FA8
         iW6TaooTOs+64skLGiISh+hFs4EIRzAqIfe8Ip11LVFEXpnf5HffRffqwmoToetY8Icx
         6QJA==
X-Gm-Message-State: AOAM530GiXCGknPWymNKVrPncD+VsS/9+G9cVtBWnOoWjElk+JWUZhgD
        bQA8nfdMWrm3XnMIBu2rw7Xqm6lKXZpi9V/UoAuxS/xDdz0xj6aLCXulwZiUI8JNht7nUzCigz6
        RdoTGXlRHIu3u
X-Received: by 2002:a05:6e02:1581:b0:2c2:5aef:db32 with SMTP id m1-20020a056e02158100b002c25aefdb32mr9958610ilu.158.1652194860680;
        Tue, 10 May 2022 08:01:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4uw1f1KcnIVJRERNnof9GFlhBvJCRdG/rb9nEoWLR23yvG31IbGKGpnEx9phxYhVtXO/jQA==
X-Received: by 2002:a05:6e02:1581:b0:2c2:5aef:db32 with SMTP id m1-20020a056e02158100b002c25aefdb32mr9958575ilu.158.1652194860140;
        Tue, 10 May 2022 08:01:00 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w11-20020a05663800cb00b0032bdc27fbd0sm2711561jao.150.2022.05.10.08.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 08:00:59 -0700 (PDT)
Date:   Tue, 10 May 2022 09:00:53 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 mlx5-next 0/4] Improve mlx5 live migration driver
Message-ID: <20220510090053.56efd550.alex.williamson@redhat.com>
In-Reply-To: <YnploMZRI9jXMXAi@unreal>
References: <20220510090206.90374-1-yishaih@nvidia.com>
        <YnploMZRI9jXMXAi@unreal>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 May 2022 16:16:16 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Tue, May 10, 2022 at 12:02:02PM +0300, Yishai Hadas wrote:
> > This series improves mlx5 live migration driver in few aspects as of
> > below.
> > 
> > Refactor to enable running migration commands in parallel over the PF
> > command interface.
> > 
> > To achieve that we exposed from mlx5_core an API to let the VF be
> > notified before that the PF command interface goes down/up. (e.g. PF
> > reload upon health recovery).
> > 
> > Once having the above functionality in place mlx5 vfio doesn't need any
> > more to obtain the global PF lock upon using the command interface but
> > can rely on the above mechanism to be in sync with the PF.
> > 
> > This can enable parallel VFs migration over the PF command interface
> > from kernel driver point of view.
> > 
> > In addition,
> > Moved to use the PF async command mode for the SAVE state command.
> > This enables returning earlier to user space upon issuing successfully
> > the command and improve latency by let things run in parallel.
> > 
> > Alex, as this series touches mlx5_core we may need to send this in a
> > pull request format to VFIO to avoid conflicts before acceptance.  
> 
> The PR was sent.
> https://lore.kernel.org/netdev/20220510131236.1039430-1-leon@kernel.org/T/#u

For patches 2-4, please add:

Reviewed-by: Alex Williamson <alex.williamson@redhat.com>

Thanks,
Alex

