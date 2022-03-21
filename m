Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67674E2C57
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 16:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350354AbiCUPdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 11:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350353AbiCUPdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 11:33:42 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F1C16E20E
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:32:14 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id dr20so30208208ejc.6
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 08:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=GtKlle4ASKp41BxP2vlyE1Y62OLmlDx2r0vsFsofbaI26Q/TGdSDLtxaIvwj3MAcTM
         jiStuGmEawU6gfL8Na5tdzVmtTyZY0zLypE5rS0qnrB9seVhywsVllHW7tyEThWvUyhE
         6PkQbUY02uSS7y83yjv3rXSSNFNdV+5+8dytmVadqVNFz8KR1E0X8ZDLb/QU+uTNi7Vp
         cuHfTGPaNShPgSFkq0/aFPF5hKCFaufUAh7bR8fVtA3GyPHX0jVXbppNRQVQcj3IpHHL
         zkchKqHJPUfBzUW9F5uuvDqiYfP4SjPIXDobHHYOZ6/G9t46GNQfNP7zltTsHI/4PMqz
         oP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=PZHmYHTa5935ei5yB7qRll9vwNexxNFdEvusI3FWxCQZQV4+THYnULw/O39bxTSx0w
         fNcw3nSd9jysX5nbw+oI1MaEijitzEQ2jCnFhOniDsjRDm+1qtNsbh3BjNcogd+2+ZF3
         hDi0EbmDBf8yfyaeqDgmJ7GrTQPktnF3fAxrUHvHLz0krA+xf2UTQz294ppn1OQG0HIL
         699vD9aUYzyxJ8+94aGOLraYTN7spEBo7ikwqKEI7uaalZLzq4P95VqTwzSSz3x1B2hi
         SoqUFy9rXTnVoDmqC40OJIBjZz7C9n4RmFwoDnGjpaoAp0/dMtSW9cWZRIB87TM9XRWY
         RM7g==
X-Gm-Message-State: AOAM531i2QoLrC61TCaF4BplPOqvAoRr6pvcUHTwEY5OTPVUZYGleHUu
        cweqg3i80IqYvfaoe0XuDLqQ+pqduDQ=
X-Google-Smtp-Source: ABdhPJzKluJOa3N5Pav5j4R+wxXXW9S7tc5iI6LJPeg5/0GUhJ7OO7gHr1836azB0i0xp1cL4X9jyg==
X-Received: by 2002:a17:906:58c7:b0:6da:955b:d300 with SMTP id e7-20020a17090658c700b006da955bd300mr21098296ejs.481.1647876732997;
        Mon, 21 Mar 2022 08:32:12 -0700 (PDT)
Received: from avogadro.redhat.com ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id b15-20020a50cccf000000b0040f74c6abedsm7923393edj.77.2022.03.21.08.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 08:32:12 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     luofei <luofei@unicloud.com>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386: Set MCG_STATUS_RIPV bit for mce SRAR error
Date:   Mon, 21 Mar 2022 16:31:26 +0100
Message-Id: <20220321153126.166053-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220120084634.131450-1-luofei@unicloud.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


