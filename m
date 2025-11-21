Return-Path: <kvm+bounces-64269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EAE63C7BF4E
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 00:45:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B177B352324
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 23:45:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6005330FF34;
	Fri, 21 Nov 2025 23:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Q+tMdxDI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9525F2FBE01
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 23:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763768700; cv=none; b=YFxdnNj3ld4TRCZzFX3PJ4SQ6Pj+GfIxCQCQQGdpdZKIW84v2OtY4IKqZBg/pGsm2RtAmvxqic+G25ri7siiQwqpyIgYm6aVvj+1vRzsIC5CYH2E340haIJ+i6HgxL5mQRK4/rAhb9evDBADw2nZA9pnHem+qcJCVrJZOHh8b08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763768700; c=relaxed/simple;
	bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PVmwGWbh/zepG1RKa/GMbNI4DXPMMANdGjK9ys9wZLxxfqFnyZ1ujYJgyD01RjzeztGTTHYFXSBewj1Q2AZ3Fp1d5kKJfYdph64RveoyoKFmUBNXVo7sdf2slMF7sa2rdWyLik9vzCmzCdd4uPjNJE9BLh5YZtj4YXc438aslDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Q+tMdxDI; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-88246401c9eso29544566d6.1
        for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 15:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1763768697; x=1764373497; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
        b=Q+tMdxDIkYXfhGhbArV0cRrjxNICLqpDxMfcVn6I12tSlGAKpER9GWu29DpBkymHRH
         8+vkLMXGdoMlRW1a8I3ymoYVhDXsc/zbDPsgk6dDtzh5juXd/l67yjvfrH6E2PCz7eSS
         0MnjazwGK0NRKyGqz2ACeRLGXyKvPtxTJ44QTasOxTfU2yErAHu4Ks44MCuNoubORnaA
         NCszOMN2Fla6VYB5ksgTIT29Z+nNac5UtoL3AGZVjOASPrtxjkUtZa4MLYMQCVpwpWT+
         xGLv13APEgGlkzM7Ys1yHg1j8bxhQAP5ngjohGYQXdfFgg/Iu3KmptXD0DSIe/JPz0hm
         mf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763768697; x=1764373497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94wkD2Iff42VLMlQNWegA9dtRPkkPQ7m6y0iMS1EKU4=;
        b=IUz49B0qLgz7I0AYN021N2nBc2tdh3RHs6jS8a+tPTqE6nyoELskPPytW8TMA0t9dF
         4KBZNH7LHUr7EDa+1gSnOw1Jfkz6IGRsLJmE2amK5FjMiI39Cy//H6PmJrwRjA2yPS5F
         ZbG/jKJaKpBO3xspbSzP7APYsaeBQt+TTjaGtFtwGbO8Q7cWE2kaM5kncq8eDCtYzX+d
         cNNZ4CGtKf/pcZ++j3fZstmigw5ciKkpm0gXaFFRdfw5U2V955DF2nt79I7w3Qstas3v
         wDJl76eElKJi8uycwcrP6VVCOBeHiR+gar6oNLNmUf1vykqyl63H8svJYBmP8QfVC1cP
         fFsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtSZiIIc9ULTYHitWFumRbIMZBWN7/zoAIsXykfy5rZSeqcR9dnvrz6y52IWdAxmMWw8s=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAi6+KtjjHVxvn/t42+OLTZdbSXIyE7oo9KXvPwB2lBDvEH6WE
	8quAQqvsXlirkFa6YTNTAb0DvVwl4mbfUi3CidkuFVcACJPRM3CnMrzVFjQTk3eMm9g=
X-Gm-Gg: ASbGncsYh09ZYC5xAtJa0MZ48RMfJiOz0c4DuRj59hnmVW3CBRTUa/3+nDkWT+xDSTT
	BZmpLR2clMUg90BmWcByUadjNqktkkm4/67XPUfkKPOz1Iu26k0KY44Et5SRc6g3c+EZ4USTMBS
	h2rQuJs7/e9eUfTaKUz3Oir1QKSURwxzENt9TgTqHjb6VnVIyO1p8At27Zp6pnozwb4I7Bnw1n9
	T9p5JWXRSl0uOOouaXeuhtqpfmsfIImKQ2OcqH7lQaxp2p72sOAMrtp/bW2GTCK1XqiC97SkZjW
	A/EixRYZj00M44aPAX3ZQIWrrag5Z7FdElBEyXCNdz+ueS7TGOEQyVX4Co20wRUO72th8L5B9Ds
	da+n9Brm/hllKsX0iL4VnznYZcoj7MgfLcmLhANSy+ax/hTGS1YSqv3EZiPsGQDKS8DwSCp26yN
	Va4TcDp9pDXFkuLZPrzPNDjo30LX9LqSkyYc8UsbqgcGKLe76RQ9DlUmZb
X-Google-Smtp-Source: AGHT+IEos7T2Axz389Mmy3AFU8+Jfh3PFehz2HfOxc6qgzO/Its691H7QS0uM/0VDIYstKPPxEQUqg==
X-Received: by 2002:a05:6214:226c:b0:87d:fc3e:6d9b with SMTP id 6a1803df08f44-8847c525de0mr61714186d6.42.1763768697300;
        Fri, 21 Nov 2025 15:44:57 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e54c32csm48350666d6.37.2025.11.21.15.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 15:44:56 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vMaoC-00000001bmD-0arX;
	Fri, 21 Nov 2025 19:44:56 -0400
Date: Fri, 21 Nov 2025 19:44:56 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>, Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap
 entries, introduce leaf entries
Message-ID: <20251121234456.GA383361@ziepe.ca>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>

On Mon, Nov 10, 2025 at 10:21:18PM +0000, Lorenzo Stoakes wrote:
> There's an established convention in the kernel that we treat leaf page
> tables (so far at the PTE, PMD level) as containing 'swap entries' should
> they be neither empty (i.e. p**_none() evaluating true) nor present
> (i.e. p**_present() evaluating true).

I browsed through this series and want to give some encourgement that
this looks nice and is a big step forward! Lots of details to check
the conversions so I wouldn't give any tags due to lack of time..

Jason

