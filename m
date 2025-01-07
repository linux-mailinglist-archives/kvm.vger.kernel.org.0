Return-Path: <kvm+bounces-34671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E750FA03E25
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 12:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3541660AB
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2025 11:46:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3C901E1C02;
	Tue,  7 Jan 2025 11:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HlVTr3ne"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5299086328
	for <kvm@vger.kernel.org>; Tue,  7 Jan 2025 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736250363; cv=none; b=flL7qX2rib7Rj6Ac/Az6PDzUT6Lrg+3QT7kz4cOFHN4t7Fhcj8wZy6lQO+fjCESy35pbN3UCqqdY9cu24eprzI4p5yhTGmm7NsVQUvB8GRGuLlOuLMyUVKq2+2m/Mpy/IjebJTsO7ApzwxPhgPJBD6pAo8i37FNz4d4QsQ0eSyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736250363; c=relaxed/simple;
	bh=uJOm5bYIBj/lRQ6wPwQNKxEhEXFNZBZhmFHDCNIWXZc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/PXvovublTkhxYwE1jEoyhoajruCzlCIAKd89f3P0zuxEydtLlPOhV0e2qGlTiuxKQEudVXqKczOabcu7uU5GgORwLgfdnpjct4Yax/PGM1j+xc+WE1AEs46N5nGt1L4E0L/IKY+6WvHC0F+1St82zFsq4MmQaKrBihkhbniUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HlVTr3ne; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736250358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lD4QOrzRsNYasrC3n0IGBLoyR09ALTVeCEEVYB2IkKs=;
	b=HlVTr3nezH0dPl7fI5GqOpsWFrbd0HDyZAIqherP+ZrmFOSDxZqYjEoWkvz77GsPQiu2cB
	THgnmxKlc9TVzL1br16JOOVUCRVqK0c84feUQyry/OlbkZxuGHD5srXC6/H7uuCvcVqPdA
	TU5x2mI/oxqhwYobYf4M0G3mWtOimWE=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-TBnfZiRMO2O1Y1IEqtVM8g-1; Tue, 07 Jan 2025 06:45:57 -0500
X-MC-Unique: TBnfZiRMO2O1Y1IEqtVM8g-1
X-Mimecast-MFC-AGG-ID: TBnfZiRMO2O1Y1IEqtVM8g
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-84a3a4ec598so39473039f.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2025 03:45:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736250356; x=1736855156;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lD4QOrzRsNYasrC3n0IGBLoyR09ALTVeCEEVYB2IkKs=;
        b=sWEdNSc3h+/wA0ixqW4fqXc3QNiylvBbNzDbQ3Ub2uxYLS5+IBOzxiw0QBR+kU8C4M
         4zb5j6xIg8c6E7OYJCr3jIb1PM8htcUCWlhfABN6ZmQ+V/8+ySMn9XXa7hOMv7ZipXRG
         /7673xZEVvEa120SQqHBQPD+/lqX3z+EE+gx5TQZ5qAywl+DbhY3DAP+LiiC0Xnp0QLg
         YCNFPdRvbIccePx6Xj9wCQUbCOz/SBHOhZrKXxTk+SMYIveG0khtszCXemVnvsR18RvF
         UdraoYLcRJwwEyryNE92aWOjRmw5o6Kw5exjpecdLkIEL6qp9D8rBLrCXF/U8njitdVz
         Nrug==
X-Gm-Message-State: AOJu0YyhYTBPEP26v5mhr2qIHbBHRbw6j9pigDXaPT/YnhPk0KEKxC2E
	Fkj43V2+/R95vWvTfi3yUsef5yXqn4DY8dH3WMDCHL5OYQzXVrrda/Kk53oYjkYi9Z9NwHxkwdW
	JkjeytKOlW6ZKWhHTrRYa8BTYjx4J919N4O26DxzNapRwZvUriJzT0wVAZg==
X-Gm-Gg: ASbGncuQL+pGUVMcxjwVSW+jvWmoiblHPIu5LrDS0XN3pcdIPtaYLEGLaeWY0GYTOSc
	zCiWTq9AkAZiJBDOE5aw4HmaTn4Rl88ry7Bw1OciVAewhseaEesLf+rYL4UapWL42mhtgJ40sSv
	4Uw0zVU3NwtO77gS4tzrge3q7IJl0h+2/NfvqWM5Of30VC7YjciyZ0HxE73Cw3rNYBmhCxEfEso
	B5mPtTVfaPP1P75Hq9g1xYFEzI4n1f+SlNw+sDxVsNiow2wlcOpnlBWAQYD
X-Received: by 2002:a05:6e02:1a04:b0:3a7:bfc6:be with SMTP id e9e14a558f8ab-3c2d5d2a628mr137550085ab.5.1736250356590;
        Tue, 07 Jan 2025 03:45:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGWHXMEgPhkbbicAC9Ldxi95MuYLoSCuQgZJMCqfPjHvdiB3LeWRroJcOAXhLJIgad1B6jH/g==
X-Received: by 2002:a05:6e02:1a04:b0:3a7:bfc6:be with SMTP id e9e14a558f8ab-3c2d5d2a628mr137550025ab.5.1736250356217;
        Tue, 07 Jan 2025 03:45:56 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce2d260971sm6225975ab.79.2025.01.07.03.45.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 03:45:55 -0800 (PST)
Date: Tue, 7 Jan 2025 06:45:50 -0500
From: Alex Williamson <alex.williamson@redhat.com>
To: Shawn Anastasio <sanastasio@raptorengineering.com>
Cc: kvm@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Timothy Pearson
 <tpearson@raptorengineering.com>
Subject: Re: Raptor Engineering dedicating resources to KVM on PowerNV + KVM
 CI/CD
Message-ID: <20250107064550.713c2fd9.alex.williamson@redhat.com>
In-Reply-To: <8dd4546a-bb03-4727-a8c1-02a26301d1ad@raptorengineering.com>
References: <8dd4546a-bb03-4727-a8c1-02a26301d1ad@raptorengineering.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 6 Jan 2025 13:47:50 -0600
Shawn Anastasio <sanastasio@raptorengineering.com> wrote:

> Hi all,
> 
> Just wanted to check in and let the community know that Raptor
> Engineering will be officially dedicating development resources towards
> maintaining, developing, and testing the existing Linux KVM facilities
> for PowerNV machines.
> 
> To this end, we have developed a publicly-accessible CI/CD system[1]
> that performs bi-hourly automated KVM smoke tests on PowerNV, as well as
> some more advanced tests involving PCIe passthrough of various graphics
> cards through VFIO on a POWER9/PowerNV system. Access can also be
> provided upon request to any kernel developers that wish to use the test
> system for development/testing against their own trees.
> 
> If anybody has any questions about the test system, or any insights
> about outstanding work items regarding KVM on PowerNV that might need
> attention, please feel free to reach out.

Hi,

What are you supposing the value to the community is for a CI pipeline
that always fails?  Are you hoping the community will address the
failing tests or monitor the failures to try to make them not become
worse?

I would imagine that CI against key developer branches or linux-next
would be more useful than finding problems after we've merged with
mainline, but it's not clear there's any useful baseline here to
monitor for regressions.  Thanks,

Alex

> [1]
> https://gitlab.raptorengineering.com/raptor-engineering-public/kernel/kernel-developers-ci-cd-access/linux/-/pipelines/1075


